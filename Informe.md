# Pràctica de Prolog

> Copyright (c) 2025 Juan José Gómez Villegas (u1987338@campus.udg.edu), Guillem Pozo Sebastián (u1972840@campus.udg.edu)

## Prolog utilitzat

Totes les opcions de la pràctica que hem implementat funcionen amb [GNU Prolog 1.5.0](http://www.gprolog.org/), que és el que tenim instal·lat, i amb el que hem provat que funcioni cada opció de les implementades.

## Parts implementades

- Opció **esc**. Funciona correctament, la implementació fa servir el predicat **escriure_llista**, i funciona de forma recursiva.

- Opció **des**, *exercici 1*. Funciona correctament, la implementació fa servir els predicats **nombre_desubicats** i **nombre_desubicats_i**.

- Opció **sum**, *exercici 2*. Funciona correctament, la implementació fa servir els predicats **suma_desplacaments** i **suma_desplacaments_i**.

- Opció **pas**.

    - inserir, *exercici 3*. Implementat amb el predicat **a_inserir**, *i altres*, funciona correctament amb els exemples de l'enunciat, i a les opcions pas i pase.

    - capgirar, *exercici 4*. Implementat amb el predicat **a_capgirar**, *i altres*, no funciona de forma correcta, alguns exemples són diferents, surten més que a l'enunciat, i a les opcions pas i pase provoca un stackoverflow.

    - intercalar, *exercici 5*. Implementat amb el predicat **a_intercalar**, *i altres*, funciona correctament amb els exemples de l'enunciat, però la opció pas i pase no la reconeixen i mostren *Opcio incorrecte*.

    - càlcul mètrica pas, *exercici 6*. Funciona correctament, la implementació fa servir el predicat **ordenacio_minima**, i altres.

- Opció **pase**.

    - escriptura de passos, *exercici 7*. Funciona correctament, i la sortida és la dels exemples, excepte per algun salt de línia. La implementació és amb el predicat **escriure_passos**, i altres.

- Menú d'opcions i programa principal, *exercici 8*. Funciona correctament i la sortida és exactament la dels exemples, excepte per algun salt de línia. La implementació és a l'última part del fitxer de codi, i es pot trobar a partir de comentari *PROGRAMA PRINCIPAL*.

En totes les opcions intentem no repetir molt de codi de forma innecessària, per això hi ha molts predicats petits.
