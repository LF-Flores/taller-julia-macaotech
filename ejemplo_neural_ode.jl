using DiffEqFlux, OrdinaryDiffEq, Flux, Optim, Plots

# Condiciones iniciales del problema
u0 = Float32[2.0; 0.0]
datasize = 30
tspan = (0.0f0, 1.5f0)
tsteps = range(tspan[1], tspan[2], length = datasize)

# Se define y resuelve el problema con parámetros reales
function trueODEfunc(du, u, p, t)
    true_A = [-0.1 2.0; -2.0 -0.1]
    du .= ((u.^3)'true_A)'
end

prob_trueode = ODEProblem(trueODEfunc, u0, tspan)
ode_data = Array(solve(prob_trueode, Tsit5(), saveat = tsteps))

# Se define una red neuronal de con dos capas densas/lineales.
# a ésta se le agrega la asunción de que el sistema transforma 
# x hacia x^3. Esto como conocimiento previo que mejore el tiempo. 
dudt2 = FastChain((x, p) -> x.^3,
                  FastDense(2, 50, tanh),
                  FastDense(50, 2))

# Se define el problema junto con su método de resolución y tiempo al cual parar.
prob_neuralode = NeuralODE(dudt2, tspan, Tsit5(), saveat = tsteps)

# Funciones que guardarán la predicción de la red neuronal y su valor de error.
function predict_neuralode(p)
  Array(prob_neuralode(u0, p))
end

function loss_neuralode(p)
    pred = predict_neuralode(p)
    loss = sum(abs2, ode_data .- pred)
    return loss, pred
end

# Utilizado para graficar a tiempo real las predicciones realizadas.
callback = function (p, l, pred; doplot = true)
  display(l)
  # plot current prediction against data
  plt = scatter(tsteps, ode_data[1,:], label = "data")
  scatter!(plt, tsteps, pred[1,:], label = "prediction")
  if doplot
    display(plot(plt))
  end
  return false
end

# Se entrena la red neuronal utilizando la data de la resolución con parámetros reales.
# Ésto se hace en dos pasos, primero con el optimizador ADAM para acercarnos rápidamente
# al mínimo, y una vez cerca utilizamos Limited-memory BFGS para un ajuste más eficiente.
result_neuralode = DiffEqFlux.sciml_train(loss_neuralode, prob_neuralode.p,
                                          ADAM(0.05), cb = callback,
                                          maxiters = 300)

result_neuralode2 = DiffEqFlux.sciml_train(loss_neuralode,
                                           result_neuralode.minimizer,
                                           LBFGS(),
                                           cb = callback,
                                           allow_f_increases = false)

