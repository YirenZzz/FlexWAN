## SMore TE
# import Pkg
# Pkg.add("JuMP")
# Pkg.add("Gurobi")

using JuMP, Gurobi

function SMORE(env, edges, capacity, flows, demand, T, Tf)

    nedges = size(edges,1)
    nflows = size(flows,1)
    ntunnels = size(T,1)


    #CREATE TUNNEL EDGE MATRIX
    L = zeros(ntunnels, nedges)
    for t in 1:ntunnels
        for e in 1:nedges
            if in(e, T[t])
                L[t,e] = 1
            end
        end
    end

    #model = Model(solver=GurobiSolver(env, OutputFlag=0))
    model = Model(() -> Gurobi.Optimizer(env))
    set_optimizer_attribute(model, "OutputFlag", 0)
    
    model_def_time = @elapsed begin
    
    # @variable(model, Z >= 0, basename="Z")
    # @variable(model, a[1:nflows,1:size(Tf[1],1)] >= 0, basename="a")

    @variable(model, Z >= 0)
    @variable(model, a[1:nflows,1:size(Tf[1],1)] >= 0)

    for f in 1:nflows
        for t in 1:size(Tf[f],1)
        @constraint(model, sum(a[f,t] for t in 1:size(Tf[f],1)) == 1)   #the sum of all allocated bandwidths on every flow must be >= the total bandwidth for that flow
        end

    end

    @expression(model, U[e=1:nedges], sum(a[f,t] * L[Tf[f][t],e] for f in 1:nflows, t in 1:size(Tf[f],1)) / capacity[e])
    for e in 1:nedges
        @constraint(model, U[e] <= Z)   #overlapping flows cannot add up to the capacity of that link
    end


    @objective(model, Min, Z)
    end  # model_def_time end

    start = time()
    #solve(model)
    optimize!(model)
    elapsed = time() - start

    println("elapsed t ", elapsed)
    solve_runtime = solve_time(model)
    opt_runtime = solve_runtime + model_def_time

    return objective_value(model), value.(a), solve_runtime, opt_runtime
end