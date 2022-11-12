using Polynomials

function polynomials(coefficient)
    coefficientFormOfPolynomial = Polynomial(reverse(coefficient))
    productFormOfPolynomial = fromroots(1:20)
    RootsOfCoefficientForm = roots(coefficientFormOfPolynomial)
    RootsOfProductForm = roots(productFormOfPolynomial)
    return coefficientFormOfPolynomial, productFormOfPolynomial, RootsOfCoefficientForm, RootsOfProductForm
end

function calculateTheValue(coefficientFormOfPolynomial, productFormOfPolynomial, RootsOfCoefficientForm, RootsOfProductForm)
    p1 = coefficientFormOfPolynomial
    p2 = productFormOfPolynomial
    r1 = RootsOfCoefficientForm
    r2 = collect(1:20)
    valuesOfCoefficientForm = map(x -> abs(p1(x)), r1)
    valuesOfProductForm = map(x -> abs(p2(x)), r1)
    relativeError = map((x, y) -> abs(x - y), r1, r2)
    return valuesOfCoefficientForm, valuesOfProductForm, relativeError
end

function displayResults(valuesOfCoefficientForm, valuesOfProductForm, relativeError)
    for i in eachindex(valuesOfCoefficientForm)
        print("P(z_{k}) = $(valuesOfCoefficientForm[i]), p(z_{k}) = $(valuesOfProductForm[i]), |z_{k} - k| = $(relativeError[i]), \n")
    end
end

function exercise(coefficient)
    coefficientFormOfPolynomial, productFormOfPolynomial,
    RootsOfCoefficientForm, RootsOfProductForm = polynomials(coefficient)

    valuesOfCoefficientForm, valuesOfProductForm,
    relativeError = calculateTheValue(coefficientFormOfPolynomial, productFormOfPolynomial,
    RootsOfCoefficientForm, RootsOfProductForm)

    displayResults(valuesOfCoefficientForm, valuesOfProductForm, relativeError)
end

function main()
    coefficientA = [1, -210.0, 20615.0, -1256850.0,
        53327946.0, -1672280820.0, 40171771630.0, -756111184500.0,          
        11310276995381.0, -135585182899530.0, 1307535010540395.0, -10142299865511450.0, 
        63030812099294896.0, -311333643161390640.0, 1206647803780373360.0, -3599979517947607200.0,
        8037811822645051776.0, -12870931245150988800.0, 13803759753640704000.0, -8752948036761600000.0, 2432902008176640000.0]
    coefficientB = coefficientA
    coefficientB[2] = -210.0-(2^(-23))
    exercise(coefficientA)
    println()
    exercise(coefficientB)
end