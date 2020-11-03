# Taller Macao Tech: Cómputo científico en Julia
## ¿Qué es y qué no es este taller?
### Qué no es...
* No será una introducción completa al lenguaje de programación, Julia (Muy poco tiempo). Aunque **no** se asume conocimiento previo de todas maneras.
* No es un taller que pueda reemplazar completamente uno de análisis numérico
### Qué es...
* Un vistazo a la realidad de lo que puede ser crear modelos y utilizar métodos numéricos para cómputo científico en el lenguaje Julia.
* Una introducción a tópicos aplicados en ciencias e ingeniería.
## ¿Cómo usar este proyecto?
Si se desea utilizar como proyecto autocontenido, el cuaderno actual provee ya la interfaz necesaria para funcionar al abrir. No obstante, si se desean crear otros archivos y manipularlos se proveen el `Project.toml` y `Manifest.toml` para utilizar una vez dentro del directorio, el comando
```Julia
Pkg> activate . 
Pkg> instantiate
```
y de forma opcional:
```Julia
Pkg> update; precompile
```
Para inicializar la paquetería (descargar y precompilar) necesaria. Esto ya se realiza dentro de este cuaderno a continuación para facilidad de uso:

## Bibliografía
* [Documentación de SciML](https://sciml.ai/) 
* [Tutoriales de SciML](https://github.com/SciML/SciMLTutorials.jl)
* Hénon, Michel (1983), \"Numerical exploration of Hamiltonian Systems\", in Iooss, G. (ed.), Chaotic Behaviour of Deterministic Systems, Elsevier Science Ltd, pp. 53–170, ISBN 044486542X
* Aguirre, Jacobo; Vallejo, Juan C.; Sanjuán, Miguel A. F. (2001-11-27). \"Wada basins and chaotic invariant sets in the Hénon-Heiles system\". Physical Review E. American Physical Society (APS). 64 (6): 066208. doi:10.1103/physreve.64.066208. ISSN 1063-651X.
* Steven Johnson. 18.335J Introduction to Numerical Methods . Spring 2019. Massachusetts Institute of Technology: MIT OpenCourseWare, https://ocw.mit.edu. License: Creative Commons BY-NC-SA.
