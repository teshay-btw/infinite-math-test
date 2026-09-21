#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Backend.h"
#include <QQmlContext>
#include <qicon.h>

int main(int argc, char* argv[])
{
#if defined(Q_OS_WIN) && QT_VERSION_CHECK(5, 6, 0) <= QT_VERSION && QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/qt/qml/infinite_math_test/icon.png"));
    QQmlApplicationEngine engine;
    Backend backend;
    engine.rootContext()->setContextProperty("backend", &backend);// устанавливаем обьект backend видимым в qml чтобы там можно было обращаться через точку

    //////////////
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/infinite_math_test/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;
    ///////////////


    QObject* root = engine.rootObjects().first();  // берем наше главное окно
    backend.setRoot(root); // устанавливаем в классе переменную которая будет иметь доступ к окну




    QObject::connect(qApp, &QCoreApplication::aboutToQuit, [&backend]() {

        HANDLE save_game_file = CreateFileW(
            L"settings.txt",
            GENERIC_READ | GENERIC_WRITE,
            FILE_SHARE_READ | FILE_SHARE_WRITE,
            NULL,
            OPEN_ALWAYS,
            FILE_ATTRIBUTE_NORMAL,
            NULL
        );
        DWORD bytesWritten;
        string buffer;

        

        buffer += std::to_string(backend.streak);
        buffer += "\n";
        buffer += std::to_string(backend.correct);
        buffer += "\n";
        buffer += std::to_string(backend.incorrect);
        buffer += "\n";
        buffer += std::to_string(backend.overall);
        buffer += "\n";
        buffer += std::to_string(backend.is_timer_enabled);
        buffer += "\n";
        buffer += std::to_string(backend.add_negatives);
        buffer += "\n";
        buffer += std::to_string(backend.add_brackets);
        buffer += "\n";
        buffer += std::to_string(backend.show_stats);
        buffer += "\n";
        buffer += std::to_string(backend.bool_theme);
        buffer += "\n";
        buffer += std::to_string(backend.bool_numpad);
        buffer += "\n";
        buffer += std::to_string(backend.is_timer_enabled);
        buffer += "\n";
        buffer += std::to_string(backend.timer_seconds);
        buffer += "\n";
        buffer += std::to_string(backend.incorrect_percent);
        buffer += "\n";


        WriteFile(save_game_file, buffer.c_str(), buffer.size(), &bytesWritten, NULL);
        CloseHandle(save_game_file);
        });



    return app.exec();
}
