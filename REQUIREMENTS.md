# Version 1.8.3 – iPhone PWA PDF-korrigering

- Installerad iPhone-PWA är enda målmiljön i denna fas.
- Utkast har inget tilldelat fakturanummer och märks UTKAST.
- Arkiverad testfaktura visar arkivnummer i fakturans metadata och PDF.
- Visa / Dela PDF skapar A4-PDF helt offline och använder iOS delningsfunktion; ingen window.print eller popup krävs.
- Avbryt stänger förhandsgranskningen av utkast och arkiverad testfaktura.
- PDF är en förenklad dokumentrendering av befintliga fakturauppgifter, inklusive eventuell bilaga. Det är inte en pixelidentisk återgivning av HTML-layouten.
- PDF genereras vid begäran; arkiverad HTML och data sparas fortsatt lokalt. Permanent låst PDF-arkivering återstår.
- Alla dokument är TEST / DEMO och inte giltiga fakturor.
- Kräver verkligt funktionstest på installerad iPhone-PWA.

---

# Dolevi Konsult – samlad produkt- och kravspecifikation

**Dokumentversion:** 1.7.2 · **Datum:** 2026-11-21 · **Språk:** svenska  
**Referensimplementation:** webbprototyp 1.7.2 (`dolevi-prototype-v1.7.2.html`)  
**Syfte:** teknikoberoende underlag för fortsatt webb- och framtida iPhone/iOS-utveckling.  
**Statusnyckel:** **B** beslutat målkrav, **P** finns i prototyp (ej produktionsverifierat), **F** framtida krav, **Ö** öppet beslut. P betyder inte att funktionen är färdig för skarp drift.

## 1. Produktmål och principer
- **GEN-01 [B]** Mobilanpassat verktyg för enmanskonsultbolag: kunder, uppdrag, artiklar, tid/kostnader, rapporter, fakturor och betalningar.
- **GEN-02 [B]** Stöd iPhone och Windows; framtida native iPhone-app ska kunna byggas från samma affärsregler, utan beroende av nuvarande HTML eller `localStorage`.
- **GEN-03 [B]** Tid och utlägg registreras främst i efterhand. Fullständigt bokföringssystem ingår inte; extern redovisningsbyrå används.
- **GEN-04 [B]** Kunder, uppdrag, artiklar, registreringar, fakturor och betalningar är separata domänobjekt.
- **GEN-05 [B]** Historiska priser och utfärdade fakturor får inte påverkas av ändringar i register.
- **GEN-06 [B]** Ändra endast överenskomna funktioner mellan versioner; bevara övrig layout och beteende. Versionshantera krav, kod, tester och beslut.
- **GEN-07 [B]** Tidigare fakturor behöver inte importeras, men fakturanummerserien måste fortsätta från senast använda nummer.
- **GEN-08 [B]** Svenska inhemska B2B-fakturor prioriteras. EU, USA och övriga världen är framtida utökningar.

## 2. Navigation och användarupplevelse
- **UI-01 [P 1.5]** Sex flikar: **Kunder, Registrering, Artiklar, Rapporter, Fakturor, Företag**.
- **UI-02 [P 1.5]** Kund och uppdrag på *samma* flik. Varje kund i en tunn inramad ruta; uppdrag som mindre inramade rutor under kundnamnet. Ingen separat Uppdrag-flik.
- **UI-03 [P 1.5]** Kund och uppdrag har var sin separat **Redigera**-knapp i samma anda som artikelregistret.
- **UI-04 [P 1.5.1]** Klick på ett uppdrags kort på Kunder öppnar Registrering med aktuell kund och uppdrag valt. Redigera-knappen öppnar endast redigering.
- **UI-05 [P 1.5.1]** Registreringens översikt visar vald kund, valbart uppdragsfilter, **Registrera** och registrerade poster för valt uppdrag (eller alla uppdrag). Knappen öppnar formuläret. **Spara** återgår till översikten.
- **UI-06 [B]** Bevara vald kund och lämpliga senaste val inom arbetsflödet, men undvik att gamla mängder, priser, kommentarer eller datum oavsiktligt återanvänds.
- **UI-07 [B]** Datumfält för ny registrering ska vara **tomt**, även efter Spara; får inte automatiskt återställas till dagens datum.
- **UI-08 [B]** Mobil först, tydliga etiketter, rimlig kontrast, klickytor och konsekvent back-/avbryt-navigering.

## 3. Kundregister
- **KUN-01 [P]** Skapa, visa och redigera kunder.
- **KUN-02 [P]** Fält: kundnamn, e-post, fakturaadress, postnummer, postort, land (standard Sverige), organisationsnummer (frivilligt), kontaktperson (frivilligt), telefon (frivilligt), momsregistreringsnummer (frivilligt).
- **KUN-03 [P]** Standardtimpris exkl. moms, frivilligt, och betalningsvillkor i hela dagar (förvalt 30, kundspecifikt).
- **KUN-04 [B]** Kundens timpris föreslås för timartiklar men kan skrivas över vid registrering. Prisändring påverkar inte tidigare poster.
- **KUN-05 [B]** En kund kan ha flera uppdrag. Kunduppgifter återanvänds i fakturautkast, men utfärdad faktura ska bevara kopia.
- **KUN-06 [F]** Arkivera/inaktivera kunder utan att radera faktura- och registreringshistorik.

## 4. Uppdrag
- **UPP-01 [P]** Skapa, visa och redigera uppdrag kopplade till exakt en kund.
- **UPP-02 [P]** Uppdragsnamn samt frivilligt fritextfält **Er referens** (kontaktperson, beställningsnummer, projektnummer etc.).
- **UPP-03 [B]** Referensen följer uppdragets registreringar till fakturan. Om en referens: visa i fakturahuvud; om flera: gruppera fakturarader med referensrubrik och mellanrum.
- **UPP-04 [F]** Arkivering/inaktivering utan historikförlust.

## 5. Artikelregister och priser
- **ART-01 [P]** Skapa och redigera återanvändbara artiklar oberoende av kund/uppdrag.
- **ART-02 [P]** Artikeln har namn, enhet (timmar, nätter, resor, stycken etc.), frivilligt standardpris exkl. moms och typ för tidsregistrering.
- **ART-03 [B]** Artiklar kan representera arbetstid eller kostnad/utlägg såsom hotell, taxi och flyg.
- **ART-04 [B]** Registreringens pris kan alltid ändras. Pris och mängd sparas som historiskt värde på registreringen.
- **ART-05 [B]** Samma artikel med olika à-priser ska redovisas som separata fakturarader; slå inte ihop till ett missvisande gemensamt à-pris.

## 6. Registreringar
- **REG-01 [P]** Registrering knyts till kund genom uppdrag och till en artikel.
- **REG-02 [P]** Datum, artikel, mängd, à-pris exkl. moms och frivillig kommentar/anteckning.
- **REG-03 [B/P]** Tre metoder för tid: direkt antal timmar (även en hel månads timmar på en rad), manuella start-/sluttider med rastavdrag och stämpelklocka/timer.
- **REG-04 [B]** Registrera utlägg i efterhand som artiklar med antal och pris.
- **REG-05 [P]** Visa kund och uppdrag samt mängd och pris tydligt i registreringslistan; avskilj med ` · `.
- **REG-06 [P]** Redigera registrering; radera endast om posten inte reserverats av utkast eller kopplats till utfärdad faktura.
- **REG-07 [B]** Valt kund-/uppdrags-/artikelkontext ska kunna behållas när flera poster registreras; datum ska däremot vara tomt vid varje ny post.
- **REG-08 [P 1.5.1]** Spara återgår från formulär till registreringsöversikt, med ny post synlig om den matchar valt uppdragsfilter.
- **REG-11 [P 1.5.1]** Registreringsöversikten sorteras efter registreringsdatum fallande (senaste datum först); vid samma datum nyaste ID först.
- **REG-09 [B]** Beräknat belopp exkl. moms = antal × registreringens frysta à-pris.
- **REG-10 [Ö]** Exakt lagring och återupptagning av en pågående timer efter appstängning måste fastställas för iOS.

## 7. Rapporter och urval
- **RAP-01 [P]** Filtrera på datumintervall, kund, uppdrag och faktureringsstatus. Bevara tidigare godkänd filterlayout och funktion.
- **RAP-02 [P]** Visa filtrerade registreringar i ordningen **Kund → Uppdrag → Artikel**.
- **RAP-03 [P]** För varje artikel: datumordnade rader med **Datum, Artikel, Antal, Belopp exkl. moms**; summera Antal och Belopp per artikel.
- **RAP-04 [P]** När alla artiklar visats: totalbelopp exkl. moms för hela rapporten.
- **RAP-05 [B]** Rapporter används särskilt för att kontrollera totalt antal fakturerbara timmar per artikel och period.
- **RAP-06 [P]** Alla tillgängliga filtrerade registreringar förväljs; **Markera alla**, **Avmarkera alla** och manuellt val per post.
- **RAP-07 [P]** Poster reserverade av utkast får visas men inte väljas på nytt för annat utkast.
- **RAP-08 [P]** Urval med flera kunder ska skapa **ett separat fakturautkast per kund**.
- **RAP-11 [P 1.5.1]** Varje uppdragsrubrik har en markeringsruta som markerar/avmarkerar samtliga faktureringsbara poster för uppdraget inom aktuella rapportfilter. Delvis urval visas som delvis markerat. Låsta/fakturerade poster påverkas inte. Rapportsummor omfattar fortfarande samtliga filtrerade poster; fakturautkast omfattar enbart markerade.
- **RAP-09 [P/B]** CSV-export av rapportdata; verifiera format och teckenkodning i produktionsimplementation.
- **RAP-10 [B]** Summeringar ska följa samma beräkningsregler som fakturan; tydliga enheter, även när artiklar inte avser timmar.

## 8. Fakturautkast och fakturor
- **FAK-01 [P]** Skapa utkast från valda registreringar. Utkast saknar fakturanummer.
- **FAK-02 [P]** Registreringar reserveras av utkast; borttaget utkast frigör dem.
- **FAK-03 [P]** Redigera utkast: fakturadatum, betalningsvillkor (dagar), förfallodatum och frivillig fakturakommentar.
- **FAK-04 [B/P]** Kopiera kundens betalningsvillkor till nytt utkast. Förfallodatum = fakturadatum + antal dagar, om inte förfallodatum ändrats manuellt. Kundens senare ändring får inte ändra utkastets avsiktligt sparade villkor.
- **FAK-05 [P]** Fakturaperiod härleds från tidigaste och senaste registreringsdatum.
- **FAK-06 [P]** Fakturan har normalt **en summerad rad per artikel och à-pris inom varje referensgrupp**, med totalt antal och belopp exkl. moms; inga onödiga dag-för-dag-rader på huvudfakturan.
- **FAK-07 [P]** Frivillig kryssruta **Bifoga detaljerad registreringsrapport som fakturaunderlag**. I prototypen visas detaljerna i förhandsgranskning; verklig PDF-bilaga återstår.
- **FAK-08 [P]** Förhandsgranskning visar mottagare, utfärdare, datum, förfallodatum, villkor, period, referenser, summerade rader, betalningsuppgifter och totalsummor.
- **FAK-09 [F]** Utfärda faktura med unik, sammanhängande nummerserie, atomärt tilldelad vid utfärdande, aldrig på utkast.
- **FAK-10 [F]** Utfärdad faktura är oföränderlig och lagrar snapshot av kund, säljare, referenser, rader, priser, moms, betalningsvillkor och datum.
- **FAK-11 [P 1.6 / F]** Utskriftsanpassad A4-faktura och webbläsarens **Skriv ut / Spara som PDF** finns i prototypen. Inbyggd PDF-generator, arkivering, export/delning och underlag till redovisningsbyrå återstår för produktionsversionen.
- **FAK-12 [F]** Kreditfaktura med egen spårbar identitet och koppling till ursprungsfakturan; inga tysta ändringar av utfärdade fakturor.
- **FAK-13 [F]** Fakturastatus: utkast, utfärdad, skickad, delbetald, betald, krediterad (detaljerad statusmodell återstår).
- **FAK-14 [F]** Registrera manuella betalningar, datum, belopp, delbetalningar och återstående fordran; kundreskontra.
- **FAK-15 [Ö]** Sista gamla fakturanummer, nummerseriens format, hantering av annulleringar och samtidiga utfärdanden fastställs före produktionsstart.

## 9. Svenska fakturauppgifter och moms
- **SVE-01 [P]** Kund: fullständigt namn och fakturaadress; frivilligt organisationsnummer, kontaktperson, e-post och telefon.
- **SVE-02 [P]** Utfärdare under fliken Företag: registrerat företagsnamn, organisationsnummer, momsregistreringsnummer, adress, postnummer, postort, land, styrelsens sätesort, e-post, telefon, webbplats, bankgiro, plusgiro eller bankkonto, och markering **Godkänd för F-skatt**.
- **SVE-03 [B]** Skarp faktura ska ha obligatoriska fakturauppgifter enligt tillämpliga svenska moms- och aktiebolagsregler: bl.a. fakturadatum, löpnummer, parternas identitet/adress, säljarens momsregistreringsnummer, tjänstens art/omfattning, relevant datum/period, beskattningsunderlag, tillämplig momssats och momsbelopp. Utformning och undantag måste verifieras juridiskt inför driftsättning.
- **SVE-04 [P-begränsning]** Prototypen använder **illustrativ 25 % moms**, inte fullständig momslogik. Fakturor får inte utfärdas skarpt med denna beräkning utan kontroll.
- **SVE-05 [F]** Momssats och momsbehandling måste modelleras per fakturarad/transaktion, med korrekt avrundning och stöd för svenska relevanta undantag innan skarp drift.
- **SVE-06 [B]** Svenska B2B-fakturor först; internationell fakturering är separat framtida krav.

## 10. Datamodell – teknikoberoende kontrakt
- **Customer:** id, name, email, address, postalCode, city, country, orgNumber?, contactPerson?, phone?, vatNumber?, hourlyPrice?, paymentDays.
- **Project:** id, customerId, name, reference?.
- **Article:** id, name, unit, defaultPrice?, timeMode?.
- **Entry:** id, projectId, articleId, date, quantity, priceSnapshot, note?, timeStart?, timeEnd?, breakMinutes?, invoiceDraftId?/invoiceId? (exakta fältnamn varierar i prototyp).
- **CompanyProfile:** registrerat namn, orgNumber, vatNumber, address, postalCode, city, country, registeredOffice, email?, phone?, website?, bankgiro?, plusgiro?, bankAccount?, approvedFtax.
- **InvoiceDraft:** id, customerId, entryIds[], createdAt, invoiceDate, paymentDays, dueDate, manualDue, comment?, attachReport.
- **IssuedInvoice [F]:** id, invoiceNumber, issuedAt, sellerSnapshot, customerSnapshot, referenceGroups, lineSnapshots, netAmount, vatBreakdown, grossAmount, paymentDetailsSnapshot, dueDate, originalEntryIds.
- **Payment [F]:** id, invoiceId, paymentDate, amount, currency, note?.
- Alla poster behöver stabila ID:n. Radera inte refererade objekt så att historik bryts. Använd exakt decimal-/öresaritmetik för belopp i produktionskod; inte flyttalsbaserade summor.
- Detta är **logisk datamodell**, inte en låsning till nuvarande JavaScript-objekt eller en viss databas.

## 11. Säkerhet, lagring och iPhone-portering
- **TEC-01 [P]** Prototypen är en fristående HTML/JavaScript-app med webbläsarens `localStorage` och exempeldata. **Ingen säker produktionslagring, inloggning, synkronisering eller backup.**
- **TEC-02 [F]** Produktionsarkitektur, lagringsplats (lokal/iCloud/server), autentisering, behörigheter, kryptering, backup/återställning och datamigrering måste beslutas.
- **TEC-03 [F]** Bygg affärsregler som testbara moduler oberoende av webb/iOS: datum, priser, rapportgruppering, fakturarader, reservationer, nummerserie, moms, betalningsstatus.
- **TEC-04 [F]** iOS-specifik UX, offline-läge, eventuell synkronisering, delning av PDF och säker datalagring specificeras senare.
- **TEC-05 [B]** Skilj mellan krav, verifierat prototypbeteende och framtida önskemål. Inga påståenden om produktionsfärdighet baserat på enbart syntaxkontroll.
- **TEC-06 [F]** Testa särskilt datum/tidszon, sommartid, decimaler, samtidighet, backup, fakturanummer och dataintegritet.

## 12. Acceptanstester (minsta uppsättning)
1. Skapa två kunder med olika betalningsvillkor, flera uppdrag och olika referenser; kontrollera rätt kund/uppdrag i registrering och faktura.
2. Ändra kundens timpris efter registrering; tidigare registrerings pris och fakturabelopp får inte ändras.
3. Registrera flera poster i följd: samma kund/uppdrag/artikel kan ligga kvar, men datumfältet är tomt varje gång; Spara återgår till översikten.
4. Registrera samma artikel på tre datum och ytterligare en artikel; rapporten ska visa samtliga detaljrader, antalssumma per artikel och totalbelopp.
5. Skapa fakturautkast med flera kunder valda: ett utkast per kund, inga dubbla reservationer.
6. Skapa utkast med kundens 90-dagarsvillkor: förfallodatum ska bli fakturadatum + 90 kalenderdagar; manuell ändring ska kunna behållas.
7. Skapa faktura med två uppdrag med olika referenser: grupperade rader, korrekt summering per artikel/à-pris; en referens ska visas i huvud.
8. Markera **Bifoga detaljerad registreringsrapport** och kontrollera att förhandsgranskningen visar dagrader och delsummor.
9. Ta bort ett utkast: registreringarna blir valbara igen.
10. Inför skarp drift: verifiera fakturanummer, immutable snapshots, PDF, moms, betalningsregistrering och säkerhetskopiering separat.

## 13. Versionshistorik
| Version | Innehåll |
|---|---|
| 0.1 | Grundläggande kunder, uppdrag, registrering |
| 0.2 | Artiklar |
| 0.3 | Tidregistreringsmetoder |
| 0.4 | Rapporter |
| 0.5 | Fakturautkast |
| 0.6 | Urval av registreringar |
| 0.7 | Återställd rapportfilterlayout |
| 0.8 | Kundredigering och kundspecifikt timpris |
| 0.9 | Separata fakturautkast per kund från blandat urval |
| 1.0 | Uppdragsredigering och ändra/radera registreringar |
| 1.1 | Kund/uppdrag på registreringsrader, klickbart uppdrag; separator ` · ` tillagd senare |
| 1.2 | Fakturadatum, betalningsvillkor, referenser, förhandsgranskning |
| 1.2.1 | Rättning av öppning av förhandsgranskning |
| 1.2.2 | Rättning av `localDate`-fel |
| 1.3 | Kundens faktura-/kontaktuppgifter och företagets utfärdaruppgifter |
| 1.3.1 | Betalningsvillkor genom fakturaflödet och behållna registreringsval |
| 1.4 | Tomt datum efter registrering; grupperad rapport och summerade fakturarader; valbart underlag |
| 1.5 | Kunder och uppdrag på samma sida; registreringsöversikt med separat formulär |
| 1.5.1 | Klick på uppdrag öppnar registrering filtrerad till uppdrag; datum fallande; markera hela uppdrag i rapport |
| 1.6 | Traditionell A4-fakturalayout, utskrift/Spara som PDF från webbläsaren, valbar underlagssida; fortsatt demobegränsning |

## 14. Öppna beslut och avgränsningar
- Produktionsarkitektur, hosting, offline/synk, säkerhetsmodell och iPhone-distribution.
- Momsregler, avrundning, flera momssatser och rättslig validering av skarp faktura.
- Exakt fakturanummerserie och regler för utfärdande, annullering, kredit och betalning.
- Exakt beteende för timer, tidszoner och rapportexport.
- Fakturamall, PDF-layout, bilageformat, arkiveringsformat och lagringstid.
- Radering/arkivering och personuppgiftshantering.
- Import av kund-/artikelregister och eventuell export till bokföringsbyrån.
- Registreringsöversikten har uppdragsfilter med valet Alla uppdrag; utvärdera om det ska kvarstå i iOS-versionen.

**Källgrund:** tidigare kravdokument `REQUIREMENTS.md`/`REQUIREMENTS-v1.3.md`, utvecklingsbeslut i denna konversation och inspektion av prototyp 1.5. Där ett framtida beteende inte finns i prototypen har det markerats **F** eller **Ö** i stället för att påstås vara implementerat.


## Tillägg 1.6.1 – A4-utskrift och sidindelning
- **PDF-01 [P]** Utskriftsvyn skapas som separat A4-dokument med stående sidformat (`@page size: 210mm 297mm`) och fast geometri.
- **PDF-02 [P]** Första sidan har företag/kund överst, fakturametadata och artikelrader därunder. Betalningsuppgifter och sidnummer ligger i fast sidfot.
- **PDF-03 [P]** Fakturarader delas upp i flera A4-sidor med konservativ radgräns. Fortsättningssidor har kortare rubrik; totalsumman placeras på sista fakturasidan.
- **PDF-04 [Begränsning]** Webbläsarens egna sidhuvuden/sidfötter (URL, datum, filnamn) styrs av webbläsarens utskriftsinställning och kan inte avaktiveras tillförlitligt via JavaScript. För garanterat ren PDF behövs en dedikerad PDF-generator.
- **PDF-05 [Ö]** Dynamisk sidindelning efter faktisk radhöjd, långa artikelbenämningar och flersidiga detaljerade bilagor kräver fortsatt test/utveckling.
- **PDF-06 [B]** För produktionsfakturor krävs riktig PDF-generering med exakt sidindelning och utan webbläsarmetadata.


## Tillägg 1.6.3 – Kommentarer och arkiverat fakturaunderlag
- **KOM-01 [P]** Registreringens frivilliga kommentar visas under artikelbenämningen i rapportens detaljrad. Den ingår inte i artikelns totalsumma eller fakturans huvudrad.
- **KOM-02 [P]** Vid valet **Bifoga detaljerad registreringsrapport** visas samma kommentar på respektive detaljrad i fakturaunderlaget, även i utskriftsvyn.
- **KOM-03 [P]** Fakturans separata, frivilliga fakturakommentar visas fortfarande på huvudfakturan och påverkar inte registreringskommentarer.
- **KOM-04 [B/F]** Vid utfärdande måste ett oföränderligt fakturaunderlag sparas som snapshot tillsammans med fakturan, oavsett om underlaget skickades till kunden. Kopian ska bevara datum, uppdrag, referens, artikel, enhet, antal, à-pris, belopp och registreringskommentar.
- **KOM-05 [B/F]** Underlaget ska kunna visas, skrivas ut och exporteras från en utfärdad faktura i framtida kundreskontra, med fakturanummer och koppling till ursprungsfakturan.
- **KOM-06 [Begränsning]** Version 1.6.3 är en prototyp utan skarpt utfärdande eller oföränderlig arkivering. Funktionen för återhämtning av historiska fakturaunderlag implementeras med fakturautfärdande/kundreskontra.
- **KOM-07 [Ö]** Långa kommentarer och sidbrytningar i flersidiga fakturabilagor behöver testas i webbläsaren.

| 1.6.3 | Kommentarer i rapport och detaljerat fakturaunderlag; arkivkrav dokumenterat |


## Ändringar i version 1.6.3
- **PDF-07 [P]** Detaljerat fakturaunderlag: kolumnrubrik visas en gång per artikel-/à-prisgrupp på varje sida, inte för varje registrering. Om gruppen fortsätter på ny sida upprepas rubriken där. Gruppsummering bevaras.
- **PDF-08 [P]** Fakturakommentar placeras direkt mellan fakturahuvudets metadata och artikelraderna, inte vid totalsumman. Tom kommentar ger smal vit avgränsning. Kommentar får högst två manuella textrader och 160 tecken i prototypen; utskrift klipper överskjutande automatisk radbrytning. Slutlig produkt ska mäta textens faktiska höjd och validera två synliga rader utan klippning.
- **PDF-09 [B]** Fortsättningssidor, fasta betalningsuppgifter och oförändrade fakturabelopp.


## 1.6.5 – Korrigering av kommentarsfält i A4-layout
- Fakturakommentar är ett flödande block direkt efter fakturametadata och före artikeltabellen.
- Utskriftens huvud har minsta höjd men kan växa efter faktiskt kommentarinnehåll (max två rader). Artikelrader börjar först efter huvudets slut.
- Tom kommentar ger en smal vit avgränsning.
- Utskriftskontroll i webbläsare och PDF återstår; ändringen påverkar inte fakturadata eller andra arbetsflöden.


## Version 1.6.5 – Fakturaunderlagets rubriker och avstånd
- Bilagans huvudrubrik och fakturainformation ska ligga direkt ovanför detaljlistan utan reserverat tomt 25 mm-block.
- Referensrubrik visas endast när referensen ändras på samma bilagesida.
- Varje artikel/prisgrupp har en egen artikelrubrik och en enda kolumnrubrik före detaljraderna, med en slutsumma efter raderna.
- Om en grupp fortsätter på en ny sida återges gruppens rubriker där för begriplighet.
- Huvudfaktura, fakturakommentar, belopp och betalningsfot ändras inte i denna korrigering.
- Utskriften måste visuellt regressionstestas i webbläsare, särskilt med långa kommentarer och flera bilagesidor.


## Version 1.7 – Rubrik i fakturaunderlag
- Åtgärdat dubbel utskrift av texten ”Detaljerade registreringar” i bilagans underrubrik. Endast den duplicerade statiska texten i utskriftsmallen har tagits bort.


## Version 1.7 – Fakturaregister och övergång från gammalt system

- **FAK-16 [P 1.7]** Fakturor visar utkast separat från ett register för utfärdade fakturor; registervyn kan filtreras efter utfärdad, skickad, delbetald, betald och krediterad. Dessa statusar visas för befintliga data men kan ännu inte sättas via appen.
- **FAK-17 [P 1.7]** Fält för att spara **senast utfärdade fakturanummer i gamla systemet**. Detta är en referensinställning, inte ett nytt fakturanummer. Formatet kan vara alfanumeriskt.
- **FAK-18 [B]** Fakturanummerserien ska **fortsätta från gamla systemet**. Före aktivering ska format, senaste nummer och att ingen parallell utfärdning sker kontrolleras. Nya nummer tilldelas enbart vid faktisk utfärdning och inte till utkast.
- **FAK-19 [F 1.8]** Nummerallokering, oföränderliga snapshots och arkiverad faktura med detaljunderlag kräver säker, transaktionsbaserad lagring. Ingen skarp utfärdning i prototyp 1.7.
- **FAK-20 [F 1.9]** Registrering av betalningar, delbetalningar och statusövergångar samt kundreskontra.
- **FAK-21 [P 1.7]** Tidigare funktioner för att redigera, granska, skriva ut och ta bort fakturautkast är kvar.

**Acceptans 1.7:** (1) Spara och återläs senaste gamla fakturanumret; (2) kontrollera att inget utkast får fakturanummer; (3) fakturautkast går fortfarande att redigera och skriva ut; (4) registerfilter kan visa befintliga statusar utan att utfärda fakturor; (5) inga nya fakturor eller betalningar skapas genom registervyn.

**Begränsning:** HTML-prototypen använder `localStorage`. Den är inte lämplig för riktiga fakturanummer, arkivering eller kundreskontra utan säker backend och backup.


## Version 1.7.1 – Appkonfiguration
- Konfiguration finns under **Företag → Öppna appkonfiguration**, efter företagets egna uppgifter. Fakturanummerserien visas inte längre på fliken Fakturor.
- **Nästa fakturanummer** är ett redigerbart, lokalt sparat testvärde. **Senast utfärdade fakturanummer i gamla systemet** behålls som referens. Varken utkast eller förhandsgranskning förbrukar fakturanummer.
- Konfigurationsfält: språk, fakturamall, standardmomssats och land/tillämpligt regelverk. Sverige och traditionell svensk A4 är aktuellt stöd. Alternativa språk, momssatser och jurisdiktioner är endast sparade framtidsval.
- Att välja annat land eller annan momssats aktiverar **inte** annan fakturalagstiftning eller momsberäkning. Prototypen visar fortfarande illustrativ svensk 25 % moms.
- Innan skarp fakturering: säker lagring, obruten nummerföljd, konflikt-/dubblettkontroll, historiska snapshots, lagstadgade fakturauppgifter och momslogik.

## Tillägg 1.7.2 – Oberoende språk och jurisdiktion
- **CFG-01 [P]** Appkonfiguration under Företag har separat fält för **Appspråk** (användargränssnitt). Val kan sparas, men full översättning är framtida arbete.
- **CFG-02 [P]** Separat **Fakturaspråk** (svenska/engelska), oberoende av appspråket. I prototypen sparas valet men fakturans språk ändras ännu inte. Framtida möjlighet till kundspecifikt fakturaspråk.
- **CFG-03 [P]** Separat **Regelverk (jurisdiktion)** anger företagets huvudsakliga rättsliga hemvist. Nu stöds endast svensk fakturalogik; val för andra jurisdiktioner är framtida förberedelser och får inte tolkas som att juridiskt stöd finns.
- **CFG-04 [B]** Appspråk, fakturaspråk, företagets jurisdiktion, kundens land och tillämplig momsbehandling för en enskild transaktion är olika begrepp och får inte automatiskt kopplas samman.
- **CFG-05 [B]** Exempel: användare kan välja engelskt appspråk med svensk jurisdiktion, eller svenskt appspråk med amerikansk jurisdiktion när amerikanskt regelstöd implementerats.
- **CFG-06 [B]** Nästa fakturanummer är redigerbart i prototypens appkonfiguration och ska vid skarp driftsättning fortsätta från gamla systemets sista nummer.
- **CFG-07 [F]** Översättningsresurser, lokaliserade format, fakturaspråk per kund och regelmoduler per jurisdiktion implementeras senare.

| 1.7.2 | Separata inställningar för appspråk, fakturaspråk och jurisdiktion; inga ändringar av skarp fakturalogik |


## Version 1.7.3 – PWA och offline-test (2026-11-21)
- Samma funktionslogik som 1.7.2, med installerbar PWA via manifest, iOS-ikon och service worker.
- Service worker cachelagrar endast appens statiska filer, så att appen kan öppnas offline efter lyckad installation och första laddning.
- Installation kräver HTTPS eller localhost; HTTP från annan enhet på LAN räcker inte för service worker.
- Appdata lagras fortfarande i webbläsarens localStorage, per origin och installationskontext; ingen synkronisering eller backup.
- PWA-test är inte godkännande för skarp fakturering.
- Testa offline efter första laddning och hemskärmsinstallation med flygplansläge.
- Ny deployment på annan domän kan ge separat lokal datalagring.


## Version 1.8 – Testarkivering och nummerserie (2026-11-22)
- **FAK-22 [P]** Utkast kan arkiveras som en uttryckligen märkt **TESTKOPIA**, inte en juridiskt utfärdad faktura. Testnumret hämtas från Företag → Appkonfiguration → Nästa fakturanummer. Endast heltal stöds i detta testflöde.
- **FAK-23 [P]** Testnumret får inte förekomma på någon annan testarkiverad faktura, och måste vara högre än sista gamla numret när det är numeriskt. Vid lyckad arkivering räknas nästa testnummer upp.
- **FAK-24 [P]** Arkivet sparar en fryst HTML-kopia av faktura och eventuellt detaljerat underlag samt snapshots av kund, företag, uppdrag och registreringar. Arkiverade testkopior kan visas och skrivas ut; utkastet kan inte längre redigeras eller tas bort.
- **FAK-25 [P]** Exportera en lokal JSON-säkerhetskopia av prototypens samtliga data från Fakturor. Import/återställning och automatisk backup återstår.
- **FAK-26 [F]** Skarp fakturautfärdning med atomisk nummerserie, korrekt moms, juridisk granskning, beständig serverlagring, återställning, och flera enheter krävs före produktionsdrift.
- **Varning:** localStorage är inte ett tillförlitligt fakturaarkiv; nummerkontroll är bara lokal och kan kringgås genom olika webbläsare/enheter. Den här versionen får endast användas med testdata.


## Version 1.8.1 – Korrigering av arkivvisning och utskrift
- **FAK-27 [P]** Arkiverad testfaktura visar sitt sparade fakturanummer i dokumentets fakturanummerfält, även för redan arkiverade kopior.
- **FAK-28 [P]** Utskrift öppnar en separat synlig A4-utskriftsvy med en knapp som användaren själv trycker på. Detta ersätter automatisk utskrift från dold iframe, som inte fungerar tillförlitligt i iOS Safari.
- **FAK-29 [P]** Arkiverad HTML-kopia visas skalad till mobilens bredd, utan att ändra arkiverade uppgifter.
- **FAK-30 [F]** Arkivering av en faktisk PDF med fast sidlayout och förhandsgranskning av samma PDF kräver separat implementation och tester. Version 1.8.1 sparar fortfarande HTML-snapshot.
- **OBS:** Safari-utskrift och sidbrytningar måste verifieras manuellt på iPhone och PC.


## Version 1.8.2 – iPhone PWA, kunder och uppdrag
- Endast installerad iPhone PWA är målplattform i denna fas. Ingen synk mellan enheter. Lokal data och export/återställning ska skyddas innan skarp användning.
- Arkiverade testfakturor: fakturanumret visas i själva fakturans metadata; befintliga arkivkopior korrigeras i visningsläge utan att ändra lagrade original.
- Utskrift från arkivvisningen använder utskrift av aktuellt dokument, utan popup-fönster; separat Avbryt-knapp stänger förhandsgranskningen. iOS Safari/PWA måste funktionstestas.
- Kund och uppdrag kan arkiveras och återaktiveras. Ingen permanent radering av historiska poster, referenser eller fakturor. Arkiverade poster döljs som standard i kundlistan och nya registreringsval.
- Standardtimpris flyttas från kund till uppdrag. Vid första öppning migreras eventuellt tidigare kundtimpris till respektive uppdrag om uppdraget saknar pris. Historiska registreringspriser ändras inte.
- Arkiverad testfaktura är fortfarande inte en juridiskt utfärdad faktura. PDF-arkivering och säker återställning återstår.
