#ifndef CODEAREA_H
#define CODEAREA_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QList>
#include <QPainterPath>
#include <QRect>

#define DEF_CODECOUNT 6					// 验证码默认位数

#define DEF_NOISYPOINTCOUNT 150			// 噪点数量
#define DEF_CONVERSEROTATE 25			// 转换角度范围
#define DEF_CONVERSESCALE 20			// 转换大小范围
#define DEF_LINECOUNT 3                 // 线的数量

//生成验证码图片的操作类
//首先生成随机的4位数，然后通过斜体，倾斜角度，位移，随机颜色来达到掩人耳目？的目的
//然后加噪点，噪点数量随机或固定一个定值(我感觉还是由窗口大小决定比较好)
//由于字体的size不好决定，所以验证码窗口不要随意调整大小

class CodeArea : public QQuickPaintedItem
{
    Q_OBJECT
public:
    explicit CodeArea(QQuickPaintedItem *parent = nullptr);
    ~CodeArea();

    /* 更换验证码图片 */
    Q_INVOKABLE void replaceCodePic();

    /* 设置验证码位数 */
    void setCodeCount(int nCodeCount);

    /* 设置噪点数量 */
    void setNoisyPointCount(int nNoisyPointCount);

    /* 设置线数量 */
    void setLineCount(int nLineCount);

    /* 检验验证码 */
    Q_INVOKABLE bool checkCode(QString sCode);

protected:
    void paint(QPainter *event);

private:
    /*初始化操作*/
    void initialization();
    /* 更新验证码 */
    inline void updateLoginCode();
    /* 更新验证码图片 */
    inline void updateCodePic();
    /* 更新用于与用户输入的验证码做比较的码 */
    inline void updateCode();
    /* 绘制边缘虚线框 */
    inline void drawOutline( QPainter * painter , bool drawBackgroundFlag = true);
    /* 绘制验证码 */
    inline void drawCode( QPainter *  painter, int nCodeIndex);
    /* 绘制噪点 */
    inline void drawNoisyPoint( QPainter *  painter);
    /* 绘制线条 */
    inline void drawLine( QPainter *  painter);
    /* 角度转换，缩放大小 */
    inline void drawConversion( QPainter *  painter);
    /* 设置验证码图片 */
    inline void setCodePic(const QList<QPainterPath *> &lCodePic);

private:
    QString m_sCode = "";						// 用于与用户输入的验证码做比较的码
    QStringList m_slCodeRange;					// 验证码生成范围
    QStringList m_slLoginCode;					// 验证码列表，用于生成验证码图片
    QPainterPath *m_pCodePic;					// 单个位的验证码图片
    QList<QPainterPath *> m_lCodePic;			// 验证码图片
    QList<Qt::GlobalColor> m_lCodeColor;		// 验证码可用颜色列表
    double angle;                               // 保存上次的角度

    int m_nNoisyPointCount = DEF_NOISYPOINTCOUNT;
    int m_nConverseRotate = DEF_CONVERSEROTATE;
    int m_nConverseScale = DEF_CONVERSESCALE;
    int m_nCodeCount = DEF_CODECOUNT;
    int m_nLineCount = DEF_LINECOUNT;
    int m_nFontPixelSize = 0;
    int m_nYLength =0;
};

#endif // CODEAREA_H
