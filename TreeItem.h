#ifndef TREEITEM_H
#define TREEITEM_H

#include <QList>
#include <QVariant>
#include <QStringList>
#include <QModelIndex>


class TreeItem
{
public:
    explicit TreeItem(TreeItem *parent = nullptr);
    TreeItem(const QVariantList& data,TreeItem *parent = nullptr);
    ~TreeItem();

    void appendChild(TreeItem *child);
    TreeItem * removeChild(TreeItem *item);
    void deleteAllChild();

    TreeItem *child(int row);
    int index(TreeItem *child);

    int childCount() const;
    int columnCount() const;
    int row() const;

    QVariant data(int column) const;
    bool setData(QVariant data,int column);

    TreeItem *parent();
    void setParent(TreeItem *parent);

private:
    TreeItem *m_parentItem;
    QList<TreeItem*> m_childItems;
    QList<QVariant> m_itemData;
};

#endif // TREEITEM_H
