#include <QCoreApplication>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTextStream>
#include <QDebug>

QString getID(QString s)
{
    QJsonDocument d = QJsonDocument::fromJson(s.toUtf8());
    QJsonObject object = d.object();
    if(object["content"].isNull())
    {
        return object["id"].toString();
    }
    else
    {
        return object["content"].toObject()["id"].toString();
    }
}

QString getCat(QString s)
{
    QStringList l = s.split("-");
    return QString(l[0]+"-"+l[1]);
}

QString getNaN(double d)
{
    if(d!=0)
    {
        return QString::number(d,'g',20);
    }
    else
    {
        return "-10";
    }
}

//tags -> DB
// no tags -> Avg

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    if(argc>=4)
    {
        QFile incoming(QCoreApplication::arguments().at(1));
        QFile outgoing(QCoreApplication::arguments().at(2));
        QFile errorfile(QCoreApplication::arguments().at(3)+"_errors");
        QMap<QString,QVector<double>> resultmap;

        QString errors("");
        QString othererrors("");

        QJsonObject object;
        QString line("");
        long errorcounter = 0;
        qInfo() << "Process has started";
        if(outgoing.open(QIODevice::ReadOnly))
        {
            QTextStream in(&outgoing);
            while (!in.atEnd())
            {
                line = in.readLine();
                QVector<double> v(3);
                object = QJsonDocument::fromJson(line.toUtf8()).object();
                v[0] = object["time"].toDouble();
//                resultmap.insert(getID(line),v);
                if(QJsonDocument::fromJson(line.toUtf8()).isObject()
                   && getID(line)!="")
                {
                    if(line.contains("started"))
                    {
                        resultmap.insert(getID(line),v);
                    }
                    if(line.contains("error"))
                    {
                        othererrors.append(line+"\n");
                    }
                }
                else
                {
//                    if(!object["error"].isNull())
//                    {
//                        resultmap.insert(getID(line),v);
////                        resultmap.insert(object["error"].toObject()["id"]
////                                .toString(),v);
//                    }
                    errors.append(line+"\n");
                    errorcounter++;
                }
            }
            outgoing.close();
        }
        qInfo() << "Read outgoing " << resultmap.count() << "with errors" <<
                   errorcounter;
        if(incoming.open(QIODevice::ReadOnly))
        {
            QTextStream in(&incoming);
            while (!in.atEnd())
            {
                line = in.readLine();
                object = QJsonDocument::fromJson(line.toUtf8()).object();
                if(object["content"].toObject()["tags"].isNull())
                {
                    //avg
                    resultmap[object["content"].toObject()["id"].toString()][2]
                    = object["time"].toDouble();
                }
                else
                {
                    //db
                    resultmap[object["content"].toObject()["id"].toString()][1]
                    = object["time"].toDouble();
                }
            }
            incoming.close();
        }
        qInfo() << "Read and inserted incoming " << resultmap.size();

        QMapIterator<QString, QVector<double>> i(resultmap);
        while (i.hasNext())
        {
            i.next();
            QFile out(QCoreApplication::arguments().at(3)+"_"+getCat(i.key()));
            if(!out.exists())
            {
                if(out.open(QIODevice::Append))
                {
                    out.write("id out dbin avgin\n");
                    out.close();
                }
            }
            if(out.open(QIODevice::Append))
            {
                QTextStream outstream(&out);
                outstream << i.key() << " "
                << getNaN(i.value().at(0)) << " "
                << getNaN(i.value().at(1)) << " "
                << getNaN(i.value().at(2)) << "\n";
                outstream.flush();
                out.close();
            }
        }
        if(errorfile.open(QIODevice::WriteOnly))
        {
            QTextStream in(&errorfile);
            in << errors;
            in << "\n";
            in << othererrors;
            in.flush();
            errorfile.close();
        }
    }
    return 0;
}
