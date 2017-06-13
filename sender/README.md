Usage
=====

Daten müssen mit import.sh in eine KairosDB geladen werden. Hierfür müssen die Daten von ftp://ftp-cdc.dwd.de/pub/CDC/ verwendet werden. Die Einstrahlungsdaten sind unter /observations_germany/climate/hourly/sun/recent zu finden. Im Ordner data/sun sollen jedoch nur die CSV enthalten sein, die aus den ZIPs zu entnehmen sind. Der Ordner data-example kann in data umbenannt werden und als Beispiel verwendet werden.

Aufruf für den Import
-----

  node import.js

Aufruf zum Start des Services
-----

  node service.js 853 20 test2 http://localhost:1880/endpoints/pvreceiver

Hinweis
-----

- KairosDB muss über localhost:8080 verfügbar sein.
