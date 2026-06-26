# AGIT Deployment Kit

> **KI-Kollaborationshinweis**  
> Dieses Projekt wurde in einer iterativen Zusammenarbeit zwischen dem Repository-Maintainer (`ctreffe`) und ChatGPT (OpenAI) konzipiert, entworfen, implementiert und dokumentiert.

Version: **1.0.0**  
Zielsystem: **Windows 11 Enterprise 25H2**  
Validiertes ISO: `SW_DVD9_Win_Pro_11_25H2.8_64BIT_German_Pro_Ent_EDU_N_MLF_X24-31690`

Das AGIT Deployment Kit ist ein modulares Windows-11-Deployment-Paket, mit dem
aus einem Installations-USB-Stick ein sauber vorkonfiguriertes lokales
Administrator-System erstellt wird.

Version 1.0.0 ist das erste stabile Release des AGIT Deployment Kits.
Sie basiert auf dem validierten 0.9.0-Release-Candidate, der eine vollständige
Neuinstallation auf echter Hardware ohne Warnungen oder Fehler abgeschlossen hat.
Nach dieser Validierung wurden keine absichtlichen Verhaltensänderungen mehr vorgenommen.

## Für wen ist das Kit gedacht?

Das Kit richtet sich an IT-Administrator:innen, die Windows 11 Enterprise von
einem vertrauenswürdigen Organisations-ISO installieren und vor einem späteren
AD-, Entra-ID-, Intune- oder sonstigen Management-Beitritt einen vorhersehbaren
lokalen Ausgangszustand haben möchten.

Man muss die PowerShell-Interna nicht verstehen, um das Kit zu verwenden. Für
ein normales Deployment werden hauptsächlich zwei Dateien bearbeitet:

1. `autounattend.xml`
2. `sources/$OEM$/$1/Deployment/Scripts/Config.ps1`

## Was macht das Kit?

Der Ablauf ist grob:

1. Windows Setup startet vom USB-Stick.
2. Windows 11 Enterprise wird automatisch ausgewählt.
3. Datenträger- und Partitionsauswahl bleiben aus Sicherheitsgründen manuell.
4. Windows OOBE wird automatisiert.
5. Ein temporärer lokaler Administrator `Setup` wird erstellt.
6. `Setup` meldet sich einmal an und startet das Deployment.
7. Der integrierte lokale `Administrator` wird aktiviert und konfiguriert.
8. Der temporäre Benutzer `Setup` wird gelöscht.
9. Das Gerät startet neu und meldet sich einmal als `Administrator` an.
10. Benutzer- und Systemkonfigurationsmodule laufen.
11. AutoLogon wird wieder deaktiviert.
12. Eine Zusammenfassung und ein Validierungsbericht werden geschrieben.

## Was macht das Kit bewusst nicht?

Das Kit tut bewusst **nicht** Folgendes:

- Datenträger automatisch löschen;
- Microsoft Defender deaktivieren;
- SmartScreen deaktivieren;
- UAC deaktivieren;
- Windows Update deaktivieren;
- Windows-Systemkomponenten entfernen;
- OneDrive-, Teams- oder Copilot-Binaries entfernen;
- breit angelegte „Debloat“- oder „Privacy-Hardening“-Skripte anwenden.

Ziel ist ein wartbares Administrator-System, keine stark veränderte oder schwer
supportbare Windows-Installation.

## Projektprinzipien

- Sicherheit vor Automatisierung.
- Datenträger- und Partitionsauswahl bleiben manuell.
- Windows bleibt wartbar und unterstützbar.
- Bevorzugt werden nachvollziehbare, Microsoft-nahe Richtlinien und Registry-
  Einstellungen.
- Defender, SmartScreen, UAC und Windows Update werden nicht deaktiviert.
- Jedes Modul muss idempotent sein.
- Jedes Modul schreibt ins Log.
- Kosmetische Fehler dürfen das Deployment nicht abbrechen.
- Keine versteckte Magie: wichtige Entscheidungen werden dokumentiert.

## Schnellstart

1. Windows-Installationsstick mit Rufus erstellen.
2. Inhalt dieses Pakets ins Root-Verzeichnis des USB-Sticks kopieren.
3. `autounattend.xml` bearbeiten.
   - `CHANGE_ME_SETUP_PASSWORD` an beiden Stellen ersetzen.
4. `sources/$OEM$/$1/Deployment/Scripts/Config.ps1` bearbeiten.
   - `CHANGE_ME_SETUP_PASSWORD` ersetzen.
   - `CHANGE_ME_ADMIN_PASSWORD` ersetzen.
5. Zielsystem vom USB-Stick booten.
6. Zielpartitionen manuell auswählen/löschen/erstellen.
7. Deployment durchlaufen lassen.
8. `C:\Windows\Temp\Deployment.log` prüfen.

## Rufus-Empfehlungen

Rufus sollte so verwendet werden:

| Rufus-Einstellung | Empfohlener Wert |
| --- | --- |
| Partitionsschema | **GPT** |
| Zielsystem | **UEFI ohne CSM** |
| Dateisystem | Rufus entscheiden lassen |
| Windows-Anpassungen von Rufus | **Alle Häkchen aus** |

Die Windows-Anpassungsoptionen von Rufus können eigene Antwortdatei-Logik
erzeugen. Das AGIT Deployment Kit sollte die einzige Komponente sein, die das
Windows-Setup anpasst.

## Passwörter

Es gibt zwei Passwörter.

| Passwort | Wo ändern? | Zweck | Existiert nach dem Deployment? |
| --- | --- | --- | --- |
| `SetupPassword` | `autounattend.xml` und `Config.ps1` | Temporärer Bootstrap-Benutzer während OOBE | Nein, `Setup` wird gelöscht |
| `AdminPassword` | `Config.ps1` | Integrierter lokaler Administrator | Ja |

### SetupPassword

`SetupPassword` wird für den temporären lokalen Benutzer `Setup` verwendet.
Windows erstellt dieses Konto während OOBE, bevor PowerShell-Skripte verfügbar
sind. Deshalb muss derselbe Platzhalter in **beiden** Dateien ersetzt werden:

- `autounattend.xml`
- `Config.ps1`

Auch wenn der Benutzer `Setup` nur temporär existiert, ist er währenddessen ein
lokaler Administrator. Platzhalterpasswörter sollten daher nicht produktiv
verwendet werden.

### AdminPassword

`AdminPassword` wird für den integrierten lokalen `Administrator` verwendet. Das
ist das Konto, das nach dem Deployment übrig bleibt und für die temporäre lokale
Administration gedacht ist, bis das Gerät einer Domäne beitritt oder anderweitig
verwaltet wird.

## Konfigurationsdatei

Die meisten Einstellungen werden hier gesteuert:

```text
sources/$OEM$/$1/Deployment/Scripts/Config.ps1
```

`$true` aktiviert eine Option, `$false` deaktiviert sie.

Die Konfigurationsdatei enthält bewusst ausführliche Kommentare. Die folgende
Referenz ist als verständliche Übersicht für Administrator:innen gedacht, die
nicht direkt den PowerShell-Code lesen möchten.

## Konfigurationsreferenz für Administrator:innen

### Explorer und Shell

| Einstellung | Standard | Was macht sie? | Warum ist das nützlich? | Wann auf `$false` setzen? |
| --- | --- | --- | --- | --- |
| `ShowFileExtensions` | `$true` | Zeigt Dateiendungen wie `.exe`, `.cmd`, `.ps1`, `.txt`. | Reduziert Verwechslungen bei Installern und Skripten. | Selten; nur wenn Windows-Standard gewünscht ist. |
| `ShowHiddenFiles` | `$true` | Zeigt versteckte Dateien und Ordner. | Nützlich für Administration und Fehlersuche. | Wenn das Gerät später direkt an Endanwender:innen geht. |
| `ExplorerOpenThisPC` | `$true` | Explorer startet mit „Dieser PC“. | Schneller Zugriff auf Laufwerke und Systemorte. | Wenn die Windows-11-Startansicht gewünscht ist. |
| `ClassicContextMenu` | `$true` | Aktiviert das klassische vollständige Rechtsklickmenü. | Spart Klicks bei administrativen Arbeitsabläufen. | Wenn das moderne Windows-11-Menü gewünscht ist. |

### Taskleiste

| Einstellung | Standard | Was macht sie? | Warum ist das nützlich? | Wann auf `$false` setzen? |
| --- | --- | --- | --- | --- |
| `TaskbarLeftAligned` | `$true` | Richtet Taskleisten-Symbole linksbündig aus. | Vertrautes Layout für viele Administrator:innen. | Wenn zentrierte Windows-11-Symbole gewünscht sind. |
| `DisableWidgets` | `$true` | Deaktiviert bzw. versteckt Widgets. | Entfernt einen für Admin-Systeme meist unnötigen Consumer-Einstiegspunkt. | Wenn Widgets genutzt werden sollen. |
| `KeepSearchBox` | `$true` | Dokumentiert, dass das Suchfeld bewusst sichtbar bleibt. | Macht die Designentscheidung explizit. | Aktuell nur Dokumentationsoption. |

### Microsoft-Standardeinstellungen

| Einstellung | Standard | Was macht sie? | Was macht sie nicht? | Empfehlung |
| --- | --- | --- | --- | --- |
| `DisableOneDrive` | `$true` | Verhindert OneDrive-Integration über Policy-artige Registry-Werte. | Deinstalliert OneDrive nicht. | Ja, für lokale Admin-Staging-Systeme. |
| `DisableTeamsAutostart` | `$true` | Verhindert automatischen Teams-Start. | Deinstalliert Teams nicht. | Ja. |
| `DisableCopilot` | `$true` | Deaktiviert Copilot über Policy-artige Registry-Werte und versteckt Einstiegspunkte, soweit möglich. | Entfernt keine Windows-Komponenten. | Ja, außer Copilot wird benötigt. |
| `DisableConsumerFeatures` | `$true` | Reduziert Microsoft-Consumer-Vorschläge und beworbene Erlebnisse. | Entfernt Apps nicht aggressiv. | Ja. |

### Datenschutz

| Einstellung | Standard | Was macht sie? | Design-Hinweis |
| --- | --- | --- | --- |
| `ReduceTelemetry` | `$true` | Reduziert Diagnosedatenerfassung über konservative Policy-artige Werte. | Bricht Windows Update, Defender oder Enterprise-Management nicht. |
| `DisableAdvertisingId` | `$true` | Deaktiviert die benutzerbezogene Werbe-ID. | Risikoarme Datenschutzvoreinstellung. |
| `DisableTipsAndSuggestions` | `$true` | Reduziert Windows-Tipps und Empfehlungen. | Hält die Oberfläche ruhiger. |
| `ReduceFeedbackPrompts` | `$true` | Reduziert Feedback-Abfragen, soweit unterstützt. | Vermeidet Unterbrechungen. |

### Sicherheit

| Einstellung | Standard | Was macht sie? | Was macht sie nicht? |
| --- | --- | --- | --- |
| `DisableAutomaticDeviceEncryption` | `$true` | Verhindert, dass Windows während oder kurz nach dem Setup automatisch Geräteverschlüsselung aktiviert. | Entfernt BitLocker nicht und verhindert keinen späteren bewussten BitLocker-Rollout. |

Das Kit lässt diese Windows-Sicherheitsfunktionen bewusst unverändert:

- Microsoft Defender
- SmartScreen
- UAC
- Windows Update

## Empfohlene Konfigurationsprofile

### Standardprofil für Administrator-Staging

Die Standardwerte verwenden. Das ist das vorgesehene Profil, um ein Gerät lokal
vorzubereiten, bevor es AD oder einer anderen Verwaltungsplattform beitritt.

### Näher am Windows-Standard

Wenn das System näher an Windows 11 Standard bleiben soll:

```powershell
ClassicContextMenu = $false
TaskbarLeftAligned = $false
ShowHiddenFiles    = $false
```

### Endbenutzerprofil

Das Kit ist nicht primär als Endbenutzer-Image gedacht. Falls es dennoch als
Basis dafür dient, können administratororientierte Explorer-Einstellungen
reduziert werden:

```powershell
ShowHiddenFiles    = $false
ShowFileExtensions = $true
ExplorerOpenThisPC = $false
```

## Erwarteter Ablauf

1. Vom USB-Stick booten.
2. Windows Setup wählt Windows 11 Enterprise automatisch.
3. Datenträger-/Partitionsauswahl bleibt manuell.
4. OOBE wird automatisiert.
5. Temporärer Benutzer `Setup` meldet sich einmal an.
6. Integrierter `Administrator` wird aktiviert und konfiguriert.
7. `Setup` wird gelöscht.
8. Das System startet neu und meldet sich einmal als `Administrator` an.
9. Benutzer- und Systemkonfigurationsmodule laufen.
10. AutoLogon wird deaktiviert.
11. Validierungsbericht und Deployment-Zusammenfassung werden geschrieben.

## Logdatei

Deployment-Log:

```text
C:\Windows\Temp\Deployment.log
```

Log-Level:

| Level | Bedeutung |
| --- | --- |
| `INFO` | Normaler Fortschritt oder Erklärung |
| `OK` | Erfolgreiche Aktion |
| `WARNING` | Nicht kritisches Problem; Deployment läuft weiter |
| `ERROR` | Kritisches Problem |

Ein Deployment gilt als erfolgreich, wenn die abschließende Zusammenfassung
meldet:

```text
Status : SUCCESS
ERROR  : 0
```

## Validierungsbericht

Am Ende führt das Kit einen Selbsttest durch. Es prüft unter anderem:

- integrierter Administrator aktiviert;
- temporärer Benutzer `Setup` gelöscht;
- AutoLogon deaktiviert;
- Explorer- und Taskleisten-Einstellungen;
- klassisches Kontextmenü;
- OneDrive-, Copilot- und Telemetrie-Policy-Werte.

Die Validierung dient als schneller operativer Plausibilitätscheck. Sie ersetzt
keine administrative Endkontrolle, bevor ein Gerät übergeben wird.

## Enthaltene Module

- Explorer-Standardeinstellungen
- Taskleisten-Standardeinstellungen
- Klassisches Windows-11-Kontextmenü
- OneDrive-Policy
- Teams-Autostart-Bereinigung
- Copilot-Policy
- Konservative Datenschutzvoreinstellungen
- Verhinderung automatischer Geräteverschlüsselung
- Validierungsbericht

## Fehlerbehebung

### Ich bleibe im Setup-Benutzer hängen

Prüfe:

```text
C:\Windows\Temp\Deployment.log
```

Wenn das Log nicht existiert, wurde `FirstBoot.ps1` vermutlich nicht gestartet.
Prüfe, ob der USB-Stick den Ordner `sources/$OEM$/$1/Deployment/Scripts`
enthält und ob `FirstLogonCommands` in `autounattend.xml` auf den richtigen
Skriptpfad zeigt.

### Im Log steht eine WARNING

Warnings sind nicht kritisch. Häufig bedeutet das nur, dass eine kosmetische
Änderung nicht sofort sichtbar aktualisiert werden konnte und nach der nächsten
Anmeldung greift.

### Taskleiste oder Explorer aktualisieren sich nicht sofort

Einige Shell-Einstellungen benötigen einen Explorer-Neustart oder eine neue
Anmeldung. Der Registry-Wert kann bereits korrekt sein, auch wenn die sichtbare
Oberfläche später aktualisiert wird.

### Windows fragt nach Sprache, Tastatur oder Konto

Dann wurde die Antwortdatei vermutlich nicht wie erwartet verarbeitet. Prüfe:

- `autounattend.xml` liegt im Root des USB-Sticks;
- Rufus-Windows-Anpassungen wurden nicht genutzt;
- die Datei wurde nicht mit defektem Encoding gespeichert;
- das Ziel-ISO enthält weiterhin das erwartete Windows-11-Enterprise-Image.

## Sicherheitshinweise

- Es ist keine automatische Datenträgerlöschung konfiguriert.
- Defender bleibt aktiviert.
- SmartScreen bleibt unverändert.
- UAC bleibt unverändert.
- BitLocker wird nicht entfernt; nur automatische Geräteverschlüsselung wird verhindert.
- OneDrive und Copilot werden über Policy-artige Registry-Werte deaktiviert,
  nicht durch Löschen von Systemkomponenten.
- Passwörter stehen im Klartext auf dem USB-Stick. Der Stick ist daher als
  sensibles Administrationsmedium zu behandeln.

## Release-Status

Version 1.0.0 ist das erste stabile Release des AGIT Deployment Kits. Sie basiert
auf dem validierten 0.9.0-Release-Candidate und enthält nach dem finalen
erfolgreichen Hardwaretest keine absichtlichen Verhaltensänderungen mehr.

Details zum Release stehen in `RELEASE.md`. Die Projektprinzipien stehen in
`PHILOSOPHY.md`.
