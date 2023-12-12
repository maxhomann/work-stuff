# Cascara deleted repositories

Alle  gelöschten Repositories der Organisation finden hier ihre vorerst letzte Ruhe, bis wir die grundlegende Struktur der Organisations aufgebaut haben. Dieses Repository läuft 2022-10 ab und wird dann ebenfalls gelöscht.

## Erstellen von Archiven

Das `create-bundle.sh` Skript erzeugt mittels `git bundle` eine `.bundle` file im aktuellen Ordner, welche die gesamte Git Historie enthält. Dafür wird das Repository lokal neu gecloned und dann gespeichert. Das Skript arbeitet mit relativen Pfaden ausgehend von diesem Ordner.

## Wiederherstellen von Repositories

Mit `restore-bundle.sh` können bundles in ein neues lokales Git wiederhergestellt werden. Mit einem Git Tool seiner Wahl kann man sich alle Branches anschauen und die verschiedenen Stände wiederherstellen. 
