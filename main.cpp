#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Backend.h"
#include <QQmlContext>
#include <qicon.h>

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN) && QT_VERSION_CHECK(5, 6, 0) <= QT_VERSION && QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/qt/qml/math/icon.png"));
    QQmlApplicationEngine engine;
    Backend backend;
    engine.rootContext()->setContextProperty("backend", &backend);// устанавливаем обьект backend видимым в qml чтобы там можно было обращаться через точку
    
    //////////////
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/math/main.qml")));
    
    if (engine.rootObjects().isEmpty())
        return -1;
    ///////////////


    QObject* root = engine.rootObjects().first();  // берем наше главное окно
    backend.setRoot(root); // устанавливаем в классе переменную которая будет иметь доступ к окну
  
    
    return app.exec();
}
