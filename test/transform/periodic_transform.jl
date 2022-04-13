@testset "periodic_transform" begin
    @testset "compare to periodic exponentiated quadratic" begin
        rng = MersenneTwister(123456)
        f = rand(rng) + 2.0
        x = collect(range(0.0, 3.0 / f; length=1_000))

        # Construct in the usual way.
        k_eq_periodic = PeriodicKernel(; r=[sqrt(0.25)]) ∘ ScaleTransform(f)

        # Construct using the periodic transform.
        k_eq_transform = SqExponentialKernel() ∘ PeriodicTransform(f)

        @test kernelmatrix(k_eq_periodic, x) ≈ kernelmatrix(k_eq_transform, x)
    end

    @testset "AD" begin
        test_ADs(x -> SEKernel() ∘ PeriodicTransform(exp(x[1])), [2.3])
    end
end
