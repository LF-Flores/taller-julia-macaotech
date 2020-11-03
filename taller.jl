### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ cae0afe4-1cd9-11eb-1043-ebcfa0d7db13
# Nota: Aquí el bloque begin-end es necesario por la forma en que opera nuestro
#       actual IDE, Pluto Notebook. En un script independiente de Julia no es 
#       necesario de utilizarse, aunque es válido para encapsulamiento.
begin
	import Pkg
	Pkg.activate(".")
	using DifferentialEquations, Plots
end

# ╔═╡ 33d5d3f0-1cd8-11eb-2a7c-a1e41bd39d42
md"# ¿Qué es y qué no es este taller?
## Qué no es...
* No será una introducción completa al lenguaje de programación, Julia (Muy poco tiempo). Aunque **no** se asume conocimiento previo de todas maneras.
* No es un taller que pueda reemplazar completamente uno de análisis numérico
## Qué es...
* Un vistazo a la realidad de lo que puede ser crear modelos y utilizar métodos numéricos para cómputo científico en el lenguaje Julia.
* Una introducción a tópicos aplicados en ciencias e ingeniería.
# ¿Cómo usar este proyecto?
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
"

# ╔═╡ 9de1d230-1da5-11eb-1111-ab0b443361e1
md"# Breve introducción al lenguaje
## Cualidades y filosofías
Comenzamos haciendo una comparación con otros lenguajes populares. Julia toma las siguientes características altamente buscadas de lenguajes existentes:
* Interactivo (como Python) 
* Rápido, compitiendo con velocidades de C y Fortran 
* De código abierto (a diferencia de C\# y el lenguaje Wolfram en Mathematica)
* Especializable a limpieza de datos y modelaje estadístico (similar a R) 
* Optimizado para cómputo científico (como Octave)
* Realiza cómputo y modelaje simbólico (como Mathematica)
* Poderoso en metaprogramación (como Ruby)

Algunas de las cosas que julia busca priorizar son:
* Legibilidad del código (hasta llegar a ser tan expresivo como lo que escribiríamos en un cuaderno)
* Reducir la brecha entre el concepto y el código: Escribimos como pensamos.
* La fácil optimización hacia código eficiente
* Enfoque a \"verbos\" (métodos) en lugar de \"sustantivos\" (clases). Esto principalmente por lo que llamamos Multiple Dispatch


## Multiple Dispatch
En Julia, cualquier tipo de dato puede realizar cualquier acción (método) una vez que se le sea definido. Esto significa que podemos enfocarnos en crear comportamientos que necesitemos sin pensar en que deben estar asociados a una clase para existir. 

Esto se lleva un paso más allá con **multiple dispatch**, que nos permite definir polimorficamente dicho método. Es decir que una acción, digamos `correr`, puede actuar de diferentes maneras y llamarse igual, decidiéndose su acción en el contexto de sus argumentos. Ejemplo, `correr(server::Server)` y `correr(bruno::Perro)` son la misma función, pero despachada con distinto comportamiento al momento de evaluarse.
"

# ╔═╡ c0523206-1da5-11eb-1b19-cb7103b63d28
md"# Modelos
## Preliminares de ecuaciones diferenciales
Gracias a la gran eficiencia de métodos iterativos y de álgebra lineal, la forma preferencial de pensar en ecuaciones diferenciales es en su forma de *sistema de ecuaciones de primer órden*. Esto siempre es posible de obtener mediante [reducción de órden](https://en.wikipedia.org/wiki/Ordinary_differential_equation#Reduction_of_order).

Una vez realizado, la forma que obtenemos, para ecuaciones autónomas (no dependientes de manera explícita del tiempo), es:

$$
x'(t) = F(x(t))
$$

donde $x: \mathbb{R} \rightarrow \mathbb{R}^n$ es una trayectoria en el espacio para la cual deseamos resolver y obedece la dinámica del campo vectorial:

$$F: \mathbb{R}^n \rightarrow \mathbb{R}^n$$

Esto define un sistema de $n$ ecuaciones a resolver. A continuación veremos algunos ejemplos.


## 1. Péndulo caótico
El péndulo doble es un sistema muy famosamente estudiado por exhibir un comportamiento **caótico** (cuya definición matemática es rigurosa). Sus ecuaciones del movimiento son las siguientes:

$$\frac{d}{dt}
\begin{pmatrix}
\alpha \\ l_\alpha \\ \beta \\ l_\beta
\end{pmatrix}=
\begin{pmatrix}
2\frac{l_\alpha - (1+\cos\beta)l_\beta}{3-\cos 2\beta} \\
-2\sin\alpha - \sin(\alpha + \beta) \\
2\frac{-(1+\cos\beta)l_\alpha + (3+2\cos\beta)l_\beta}{3-\cos2\beta}\\
-\sin(\alpha+\beta) - 2\sin(\beta)\frac{(l_\alpha-l_\beta)l_\beta}{3-\cos2\beta} + 2\sin(2\beta)\frac{l_\alpha^2-2(1+\cos\beta)l_\alpha l_\beta + (3+2\cos\beta)l_\beta^2}{(3-\cos2\beta)^2}
\end{pmatrix}$$

Resolveremos este sistema utilizando los métodos del paquetes `DifferentialEquations.jl`. 

El movimiento generado por esta ecuaciones se ve similar a:
"

# ╔═╡ 70ac4432-1dad-11eb-2ffc-bdb991592480
html"
<p align='center'>
<img width='216' height='190' src='https://upload.wikimedia.org/wikipedia/commons/6/65/Trajektorie_eines_Doppelpendels.gif'>
</p>
"

# ╔═╡ 02926624-1da9-11eb-1b45-b5268512ebb9
# El prefijo const es opcional y no significa VALOR constante, si no tipo constante.
begin
	const m₁, m₂, L₁, L₂, g = 1, 2, 1, 2, 9.81
	initial = [0, π/3, 0, 3pi/5]
	tspan = (0., 50.)
end;

# ╔═╡ 80b59058-1da9-11eb-3e67-8170a6930d2b
md"Se define una función auxiliar para transformar de coordenadas polares a cartesianas:"

# ╔═╡ 7449c578-1da9-11eb-0373-d529c7d1aa51
function polar2cart(sol; dt=0.02, l1=L₁, l2=L₂, vars=(2,4))
    u = sol.t[1]:dt:sol.t[end]

    p1 = l1*map(x->x[vars[1]], sol.(u))
    p2 = l2*map(y->y[vars[2]], sol.(u))

    x1 = l1*sin.(p1)
    y1 = l1*-cos.(p1)
    (u, (x1 + l2*sin.(p2),
     y1 - l2*cos.(p2)))
end

# ╔═╡ 8bbe3dec-1da9-11eb-3376-47c99c6bd393
function double_pendulum(xdot,x,p,t)
    xdot[1] = x[2]
    xdot[2] = - ((g*(2*m₁+m₂)*sin(x[1]) + m₂*(g*sin(x[1]-2*x[3]) + 
				2*(L₂*x[4]^2+L₁*x[2]^2*cos(x[1]-x[3]))*sin(x[1]-x[3])))/
		        (2*L₁*(m₁+m₂-m₂*cos(x[1]-x[3])^2)))
    xdot[3] = x[4]
    xdot[4] = (((m₁+m₂)*(L₁*x[2]^2+g*cos(x[1])) + 
			   L₂*m₂*x[4]^2*cos(x[1]-x[3]))*sin(x[1]-x[3]))/
			   (L₂*(m₁+m₂-m₂*cos(x[1]-x[3])^2))
end

# ╔═╡ d2a2721e-1da9-11eb-1eea-d3a584fafa8e
double_pendulum_problem = ODEProblem(double_pendulum, initial, tspan);

# ╔═╡ ec5d56a6-1da9-11eb-1fc4-57840baed98d
sol = solve(double_pendulum_problem, Vern7(), abs_tol=1e-10, dt=0.05)

# ╔═╡ 3317fbdc-1daa-11eb-1d17-6791df36b6e4
begin
	ts, ps = polar2cart(sol, l1=L₁, l2=L₂, dt=0.01)
	plot(ps...)
end

# ╔═╡ 61376792-1dae-11eb-02fa-93e6782be478
md"## 2. Sistema de Hénon-Heiles 
Es un sistema dinámico que modela el movimiento de una estrella orbitando alrededor de su centro galáctico mientras yace restringido en un plano. Éste es un ejemplo de un sistema Hamiltoniano, y tiene la forma:

$$
\begin{align}
\frac{d^2x}{dt^2}&=-\frac{\partial V}{\partial x}\\
\frac{d^2y}{dt^2}&=-\frac{\partial V}{\partial y}
\end{align}
$$

donde

$$V(x,y)={\frac {1}{2}}(x^{2}+y^{2})+\lambda \left(x^{2}y-{\frac {y^{3}}{3}}\right).$$

es conocido como el **potencial de Hénon–Heiles**. De éste puede derivarse su Hamiltoniano:

$$H={\frac {1}{2}}(p_{x}^{2}+p_{y}^{2})+{\frac {1}{2}}(x^{2}+y^{2})+\lambda \left(x^{2}y-{\frac {y^{3}}{3}}\right).$$

Esta cantidad representa un invariante del sistema dinámico: Una cantidad conservada. En este caso, es la energía total del sistema.
"

# ╔═╡ cc7905be-1daf-11eb-33d3-9d354f8d9419
begin
	# Parámetros
	initial₂ = [0.,0.1,0.5,0]
	tspan₂ = (0,100.)
	# V: Potencial, T: Energía cinética total, E: Energía total
	V(x,y) = 1//2 * (x^2 + y^2 + 2x^2*y - 2//3 * y^3)
	E(x,y,dx,dy) = V(x,y) + 1//2 * (dx^2 + dy^2);
end;

# ╔═╡ ab323b54-1db0-11eb-0d16-2b909c5a4a16
md"Definimos el modelo en una función:"

# ╔═╡ 4c4d367a-1db0-11eb-0363-27634674bbfe
function Hénon_Heiles(du,u,p,t)
    x  = u[1]
    y  = u[2]
    dx = u[3]
    dy = u[4]
    du[1] = dx
    du[2] = dy
    du[3] = -x - 2x*y
    du[4] = y^2 - y -x^2
end

# ╔═╡ a9f31cc2-1db0-11eb-3df5-2f65f8d96d67
md"Resolvemos el problema:"

# ╔═╡ 279aff64-1db1-11eb-2ce5-7955f39dd250
begin
	prob₂ = ODEProblem(Hénon_Heiles, initial₂, tspan₂)
	sol₂ = solve(prob₂, Vern9(), abs_tol=1e-16, rel_tol=1e-16);
end

# ╔═╡ e47793e6-1db0-11eb-2ac5-511dbb2dbaa8
plot(sol₂, vars=(1,2), title = "Órbita del sistema de Hénon-Heiles", xaxis = "x", yaxis = "y", leg=false)

# ╔═╡ 3a2ad3a6-1db2-11eb-136e-93feebbe9377
md"Parece estar correctamente resuelto pero... examinando la evolución de la energía total/Hamiltoniano podemos encontrar lo siguiente:"

# ╔═╡ 0fb21260-1db2-11eb-211b-d7a3cc0c3aa9
begin
	energy = map(x->E(x...), sol₂.u)
	plot(sol₂.t, energy .- energy[1], title = "Cambio de la energía en el tiempo", xaxis = "Número de iteraciones", yaxis = "Cambio en energía")
end

# ╔═╡ 168fa38a-1db3-11eb-02f8-b547454f2511
md"¡La energía total cambia! Eso quiere decir que la ley de conservación que esperamos que se cumpla físicamente no parece cumplirse en nuestra simulación. Esto delata un error en la resolución de la ecuación, específicamente por el método utilizado.

Para evitar eso, podemos utilizar algo conocido como un **integrador simplético** que considere la estructura de sistema Hamiltoniano que tiene nuestras ecuaciones.

Éste lo implementamos a continuación:"

# ╔═╡ 64f336f8-1db4-11eb-3d08-45ce58c5a127
function HH_acceleration!(dv,v,u,p,t)
    x,y  = u
    dx,dy = dv
    dv[1] = -x - 2x*y
    dv[2] = y^2 - y -x^2
end;

# ╔═╡ 7375b80e-1db4-11eb-395d-4f018f0271dc
md"Debemos ahora definir la condición inicial por separado, pues nuestro sistema, al ser Hamiltoniano, tiene una segmentación natural en esos pares de variables."

# ╔═╡ 67f80a2c-1db4-11eb-0f13-4bacb5d52f03
begin
	initial_positions = [0.0,0.1]
	initial_velocities = [0.5,0.0]
end;

# ╔═╡ b4ae1924-1db4-11eb-2f1e-b398cd26c703
md"Resolvemos el problema ahora como una ecuación de segundo orden pero con estructura simpléctica detectada:"

# ╔═╡ 72822478-1db4-11eb-3b89-13dc7ce09df1
begin
	prob₃ = SecondOrderODEProblem(HH_acceleration!, 
								 initial_velocities,
								 initial_positions,
								 tspan₂)
	sol₃ = solve(prob₃, KahanLi8(), dt=1/10)
end;

# ╔═╡ 0ffa749e-1db5-11eb-072f-67d20fd86af5
md"Ahora podemos observar cómo la energía se mantiene muy cercana a cero, oscilando solamente por errores de precisión numérica pero sin existir una tendencia de crecimiento anómala."

# ╔═╡ e20eb43c-1db4-11eb-3fcb-7fbd0ff32e0c
begin
	energy₂ = map(x->E(x[3], x[4], x[1], x[2]), sol₃.u)
	plot(sol₃.t, energy₂ .- energy₂[1], title = "Cambio de la energía en el tiempo", xaxis = "Número de iteraciones", yaxis = "Cambio en energía")
end

# ╔═╡ 4812b46e-1daf-11eb-0ff3-4f5706cd25b3
md"
# Bibliografía
* [Documentación de SciML](https://sciml.ai/) 
* [Tutoriales de SciML](https://github.com/SciML/SciMLTutorials.jl)
* Hénon, Michel (1983), \"Numerical exploration of Hamiltonian Systems\", in Iooss, G. (ed.), Chaotic Behaviour of Deterministic Systems, Elsevier Science Ltd, pp. 53–170, ISBN 044486542X
* Aguirre, Jacobo; Vallejo, Juan C.; Sanjuán, Miguel A. F. (2001-11-27). \"Wada basins and chaotic invariant sets in the Hénon-Heiles system\". Physical Review E. American Physical Society (APS). 64 (6): 066208. doi:10.1103/physreve.64.066208. ISSN 1063-651X.
* Steven Johnson. 18.335J Introduction to Numerical Methods . Spring 2019. Massachusetts Institute of Technology: MIT OpenCourseWare, https://ocw.mit.edu. License: Creative Commons BY-NC-SA.
"

# ╔═╡ Cell order:
# ╟─33d5d3f0-1cd8-11eb-2a7c-a1e41bd39d42
# ╠═cae0afe4-1cd9-11eb-1043-ebcfa0d7db13
# ╟─9de1d230-1da5-11eb-1111-ab0b443361e1
# ╟─c0523206-1da5-11eb-1b19-cb7103b63d28
# ╟─70ac4432-1dad-11eb-2ffc-bdb991592480
# ╠═02926624-1da9-11eb-1b45-b5268512ebb9
# ╟─80b59058-1da9-11eb-3e67-8170a6930d2b
# ╠═7449c578-1da9-11eb-0373-d529c7d1aa51
# ╠═8bbe3dec-1da9-11eb-3376-47c99c6bd393
# ╠═d2a2721e-1da9-11eb-1eea-d3a584fafa8e
# ╠═ec5d56a6-1da9-11eb-1fc4-57840baed98d
# ╟─3317fbdc-1daa-11eb-1d17-6791df36b6e4
# ╟─61376792-1dae-11eb-02fa-93e6782be478
# ╠═cc7905be-1daf-11eb-33d3-9d354f8d9419
# ╟─ab323b54-1db0-11eb-0d16-2b909c5a4a16
# ╠═4c4d367a-1db0-11eb-0363-27634674bbfe
# ╟─a9f31cc2-1db0-11eb-3df5-2f65f8d96d67
# ╠═279aff64-1db1-11eb-2ce5-7955f39dd250
# ╟─e47793e6-1db0-11eb-2ac5-511dbb2dbaa8
# ╟─3a2ad3a6-1db2-11eb-136e-93feebbe9377
# ╟─0fb21260-1db2-11eb-211b-d7a3cc0c3aa9
# ╟─168fa38a-1db3-11eb-02f8-b547454f2511
# ╠═64f336f8-1db4-11eb-3d08-45ce58c5a127
# ╟─7375b80e-1db4-11eb-395d-4f018f0271dc
# ╠═67f80a2c-1db4-11eb-0f13-4bacb5d52f03
# ╟─b4ae1924-1db4-11eb-2f1e-b398cd26c703
# ╠═72822478-1db4-11eb-3b89-13dc7ce09df1
# ╟─0ffa749e-1db5-11eb-072f-67d20fd86af5
# ╟─e20eb43c-1db4-11eb-3fcb-7fbd0ff32e0c
# ╟─4812b46e-1daf-11eb-0ff3-4f5706cd25b3
