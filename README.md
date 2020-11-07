# Taller Macao Tech: Cómputo científico en Julia

- PARA MÁS INFORMACIÓN SOBRE EL FUTURO CURSO A IMPARTIR DE JULIA, MANDAR CORREO A: juliaforeducation@gmail.com
- Charla de la semana de la carrera de matemática: [Aquí](https://www.facebook.com/SemanaCarreradeMatematicaUNAH/videos/810162896484095)
- Charla en colaboración con la escuela de física: [Aquí](https://www.facebook.com/fisica.unah.edu.hn/videos/692547961678076)
- Video de este taller: [Aquí](https://www.youtube.com/watch?v=onu9-V6zhYg)

## ¿Qué es y qué no es este taller?

### Qué no es...
* No será una introducción completa al lenguaje de programación, Julia (Muy poco tiempo). Aunque **no** se asume conocimiento previo de todas maneras.
* No es un taller que pueda reemplazar completamente uno de análisis numérico

### Qué es...
* Un vistazo a la realidad de lo que puede ser crear modelos y utilizar métodos numéricos para cómputo científico en el lenguaje Julia.
* Una introducción a tópicos aplicados en ciencias e ingeniería.

## Descripción de archivos
Los archivos en este repositorio son de principal utilizar a quienes tienen instalados el lenguaje de programación Julia. No obstante, se tiene un archivo `.html` para visualizar el cuaderno utilizado sin necesitar dicha instalación. Por lo demás:
* `taller.jl`: Un Pluto notebook utilizado en el taller para demostración de algunos métodos y problemas en la resolución de ecuaciones diferenciales, inspirado por algunos tutoriales de SciML citados en la bibliografía.
* `ejemplo_neural_ode`: Script de ejemplo de resolución de un sistema dinámico basado en datos mediante la integración de redes neuronales y métodos de ecuaciones diferenciales.
* `Manifest.toml` y `Project.toml`: Archivos de dependencias del proyecto.

## ¿Cómo usar este proyecto?
El cuaderno `taller.jl` puede ser ejecutado sin todas las dependencias del proyecto, pues solamente utiliza el paquete `DifferentialEquations.jl` que puede ser instalado de manera individual y `Plot.jl` que es parte de la librería estándar de Julia.

No obstante, para obtener el ambiente completo de dependencias con la cual fue probado el script `ejemplo_neural_ode.jl` de entrenamiento de la ecuación diferencial neuronal, se debe instanciar el proyecto de la siguiente manera mediante el administrador de paquetes de Julia:
```Julia
Pkg> activate . 
Pkg> instantiate
```
y de forma opcional:
```Julia
Pkg> update; precompile
```
Esto cada vez que se desee actualizar y tener precompilado los paquetes a utilizar.

## Bibliografía
* [Documentación de SciML](https://sciml.ai/) 
* [Tutoriales de SciML](https://github.com/SciML/SciMLTutorials.jl)
* Hénon, Michel (1983), \"Numerical exploration of Hamiltonian Systems\", in Iooss, G. (ed.), Chaotic Behaviour of Deterministic Systems, Elsevier Science Ltd, pp. 53–170, ISBN 044486542X
* Aguirre, Jacobo; Vallejo, Juan C.; Sanjuán, Miguel A. F. (2001-11-27). \"Wada basins and chaotic invariant sets in the Hénon-Heiles system\". Physical Review E. American Physical Society (APS). 64 (6): 066208. doi:10.1103/physreve.64.066208. ISSN 1063-651X.
* Steven Johnson. 18.335J Introduction to Numerical Methods . Spring 2019. Massachusetts Institute of Technology: MIT OpenCourseWare, https://ocw.mit.edu. License: Creative Commons BY-NC-SA.
