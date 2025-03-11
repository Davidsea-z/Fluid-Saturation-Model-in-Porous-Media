function Krw = compute_Krw(Krw0, nw, Sw, Swr, a)
    Krw = Krw0 * exp(nw * (Sw - Swr)) + a;
end