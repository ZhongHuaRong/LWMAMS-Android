#include "TreeModel.h"
#include <QDebug>

TreeModel::TreeModel(QObject *parent)
    : QAbstractItemModel(parent),
      m_rootItem(new TreeItem)
{
}

TreeModel::~TreeModel()
{
    if(m_rootItem){
        m_rootItem->deleteAllChild();
        delete m_rootItem;
    }
}

QVariant TreeModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
    switch(orientation)
    {
    case Qt::Horizontal:
        return roleNames()[role];
        break;
    case Qt::Vertical:
        return QVariant();
        break;
    }
    return QVariant();
}

QModelIndex TreeModel::index(int row, int column, const QModelIndex &parent) const
{
    // FIXME: Implement me!
    if (!hasIndex(row, column, parent))
    {
        return QModelIndex();
    }

    TreeItem *parentItem;
    if (!parent.isValid())
    {
        parentItem = m_rootItem;
    }
    else
    {
        parentItem = static_cast<TreeItem*>(parent.internalPointer());
    }

    TreeItem *childItem = parentItem->child(row);
    if (childItem)
    {
        return createIndex(row, column, childItem);
    }
    else
    {
        return QModelIndex();
    }
}

QModelIndex TreeModel::parent(const QModelIndex &index) const
{
    // FIXME: Implement me!
    if (!index.isValid())
    {
        return QModelIndex();
    }

    TreeItem *childItem = static_cast<TreeItem*>(index.internalPointer());
    TreeItem *parentItem = childItem->parent();

    if (parentItem == m_rootItem)
    {
        //qDebug()<<"parent:m_rootItem";
        return QModelIndex();
    }

    //qDebug()<<"parent:"<<parentItem->row();
    return createIndex(parentItem->row(), 0, parentItem);
}

int TreeModel::rowCount(const QModelIndex &parent) const
{
    // FIXME: Implement me!
    TreeItem *parentItem;

    if (!parent.isValid())
    {
        parentItem = m_rootItem;
    }
    else
    {
        parentItem = static_cast<TreeItem*>(parent.internalPointer());
    }
    return parentItem->childCount();
}

int TreeModel::columnCount(const QModelIndex &parent) const
{
    return 3;
    if (!parent.isValid())
        return 0;

    // FIXME: Implement me!
    if (parent.isValid())
    {
        return static_cast<TreeItem*>(parent.internalPointer())->columnCount();
    }
    else
    {
        return 3;
        return m_rootItem->columnCount();
    }
}

QVariant TreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    switch (role)
    {
    case NUM:
    {
        //qDebug()<<"data:"<<static_cast<TreeItem*>(index.internalPointer())->data(0);
        return static_cast<TreeItem*>(index.internalPointer())->data(0);
    }
    case NAME:
    {
        //qDebug()<<"data:"<<static_cast<TreeItem*>(index.internalPointer())->data(1);
        return static_cast<TreeItem*>(index.internalPointer())->data(1);
    }
    case PAGE:
    {
        //qDebug()<<"data:"<<static_cast<TreeItem*>(index.internalPointer())->data(2);
        return static_cast<TreeItem*>(index.internalPointer())->data(2);
    }
    }
	return QVariant();
}

bool TreeModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid())
        return false;
    TreeItem *childItem = static_cast<TreeItem*>(index.internalPointer());
    switch (role)
    {
    case NUM:
    {
                  return childItem->setData(value,0);
    }
    case NAME:
    {
                  return childItem->setData(value,1);
    }
    case PAGE:
    {
                  return childItem->setData(value,2);
    }
    }
    return false;
}

QHash<int, QByteArray> TreeModel::roleNames() const
{
    //qDebug()<<"roleNames";
    QHash<int, QByteArray> names(QAbstractItemModel::roleNames());
    names[NUM] = "num";
    names[NAME] = "name";
    names[PAGE] = "page";
    return names;
}

TreeItem *TreeModel::rootItem() const
{
    return m_rootItem;
}

TreeItem * TreeModel::appendChild(const QVariantList &data, TreeItem *parent)
{
    if(!parent)
        parent = m_rootItem;
    return new TreeItem(data,parent);
}

void TreeModel::appendChild(const QVariantList &data,int parentRow)
{
    appendChild(data,parentRow<0?m_rootItem:m_rootItem->child(parentRow));
}

void TreeModel::deleteAll()
{
    m_rootItem->deleteAllChild();
    resetModel();
}

void TreeModel::resetModel()
{
    beginResetModel();
    endResetModel();
}

int TreeModel::itemRow(const QModelIndex &index)
{
    return index.isValid()?static_cast<TreeItem*>(index.internalPointer())->row():-1;
}
