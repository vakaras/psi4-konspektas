===========
MIF Starter
===========

VU MIF dokumentų XeLaTeX šablonas.
Struktūra::

    ├── common          – tai kas bendra visiems;
    ├── config          – konkretaus dokumento individualizavimas;
    ├── dist            – kompiliavimo katalogas;
    └── content         – dokumento turinys.

Naujo projekto sukūrimas
========================


#.  Klonuojame saugyklą::

        git clone git://github.com/vakaras/mif-starter.git ${PROJECT}

    Čia ``${PROJECT}`` yra katalogo, į kurį bus nukopijuota saugykla
    pavadinimas.

#.  Pakeičiame numatytąją saugyklą (daroma prielaida, kad esame
    projekto kataloge)::

        git remote rename origin template
        git remote add origin ${REPOSITORY}
        git push -u origin master

    Čia ``${REPOSITORY}`` yra pagrindinės projekto saugyklos adresas.

#.  Pritaikome ``config`` esančius failus pagal savo poreikius.
#.  Susikuriame naują ``README.md`` failą::

        touch README.md

#.  Sukuriame turinio katalogą ``content`` ir nurodome jį naudoti vietoj
    pavyzdžių::

        mkdir content
        echo -e '\\chapter{Mano straipsnis}\n' > content/chapters.tex

------------------------------
Titulinio puslapio pritaikymas
------------------------------

Pavyzdžiui, jei rašome kursinį darbą, tai į ``config/global-config.tex``
pridedame::

    \docname{Komponentinis programavimas su Scala}
    \docnameen{Component-based programming with Scala}
    \doctype{Kursinis darbas}
    \authorname{Vytautas Astrauskas}
    \coursenumber{3}
    \groupnumber{2}
    \supervisorname{Darbo Vadovas}

Taip, pat galima nurodyti ir recenzentą::

    \reviewername{Recenzentas}

Taip pat galima apskritai pakeisti autoriaus informacijos rodymą::

    \authorinformation{Autorius: Vytautas Astrauskas}

Jei nenurodysime autoriaus, tai dalis su autoriaus informacija nebus
sukurta iš viso. Pavyzdžiui, taip galėtų atrodyti konspektų nustatymai::

    \docname{Psichologijos įvadas}
    \doctype{Paskaitų konspektas}
    \lecturername{Prof. habil. dr. Vardas Pavardė}

Aukštosios mokyklos pavadinimą galime pakeisti su komanda::

    \schooltitle{%
        Vilniaus universitetas\\
        Matematikos ir informatikos fakultetas\\
        Informatikos katedra%
        }

Datą (numatytoji yra metai, kada buvo sukompiliuotas dokumentas) galima
pakeisti su komanda::

    \date{2011}

Šablono atnaujinimas
====================

::

    git pull template master

Darbai
======

+   Pakeisti pavyzdžių fono spalvą į šviesiai pilką:

    +   `Bandymas panaudojant MiniPage
        <http://answers.google.com/answers/threadview?id=282787>`_
        – nelabai tinkamas, nes automatiškai nelaužo teksto per kelis
        puslapius?
    +   `Bandymas panaudojant framed
        <http://www.latex-community.org/forum/viewtopic.php?f=5&t=1441&start=0>`_;
    +   `LaTeX knygos puslapis apie spalvas
        <http://en.wikibooks.org/wiki/LaTeX/Colors>`_;
    +   `LaTeX knygos puslapis apie teoremas
        <http://en.wikibooks.org/wiki/LaTeX/Theorems>`_;
    +   fancyvrb paketas leidžia environment turinį įrašyti
        nepakeistą į failą;
    +   environ paketas leidžia kurti environment, kurių
        turinys pasiekiamas per \BODY komandą.


Naudingos nuorodos
==================

+   http://heather.cs.ucdavis.edu/~matloff/LaTeX/LookHereFirst.html
