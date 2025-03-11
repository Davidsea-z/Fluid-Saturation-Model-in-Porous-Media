function Kro = compute_Kro(Kro0, no, Sw, Sor, a)
    Kro = Kro0 * exp(no * (1 - Sw - Sor)) + a;
end