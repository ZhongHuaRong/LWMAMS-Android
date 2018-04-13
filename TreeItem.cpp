#include "TreeItem.h"
#include <QDebug>

TreeItem::TreeItem(TreeItem *parent):
    m_parentItem(parent)
{
    if(parent)
        parent->appendChild(this);
}

TreeItem::TreeItem(const QList<QVariant> &data, TreeItem* parent)
    : m_parentItem(parent)
{
    if(parent)
        parent->appendChild(this);
    m_itemData = data;
}

TreeItem::~TreeItem()
{
    qDeleteAll(m_childItems);
    m_childItems.clear();
}

void TreeItem::appendChild(TreeItem *item)
{
    if(m_childItems.indexOf(item)==-1)
        m_childItems.append(item);
    item->setParent(this);
}

TreeItem * TreeItem::removeChild(TreeItem *item)
{
    TreeItem *child=nullptr;
    if(m_childItems.indexOf(item)!=-1)
    {
        child = m_childItems.takeAt(m_childItems.indexOf(item));
    }
    return child;
}

void TreeItem::deleteAllChild()
{
    for (int index = 0; index < m_childItems.size(); index++)
    {
        m_childItems[index]->deleteAllChild();
    }
    qDeleteAll(m_childItems);
    m_childItems.clear();
}

TreeItem *TreeItem::child(int row)
{
    return row<m_childItems.length()?m_childItems.at(row):nullptr;
}

int TreeItem::childCount() const
{
    return m_childItems.count();
}

int TreeItem::columnCount() const
{
    return m_itemData.count();
    //return 1;
}

QVariant TreeItem::data(int column) const
{
    return column<m_itemData.length()?m_itemData.at(column):QVariant();
}

bool TreeItem::setData(QVariant data,int column)
{
    while(m_itemData.length()>column)
    {
        m_itemData.append(QVariant());
    }
    m_itemData.replace(column,data);

    return true;
}

TreeItem *TreeItem::parent()
{
    return m_parentItem;
}

void TreeItem::setParent(TreeItem *parent)
{
    this->m_parentItem = parent;
}

int TreeItem::row() const
{
    if (!m_parentItem) { return 0; }

    return m_parentItem->m_childItems.indexOf(const_cast<TreeItem*>(this));
}
