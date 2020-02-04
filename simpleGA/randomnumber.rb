# -*- coding: utf-8 -*-

#RandomNumber
IM1 = 2147483563
IM2 = 2147483399
AM = (1.0/IM1)
IMM1 = (IM1-1)
IA1 = 40014
IA2 = 40692
IQ1 = 53668
IQ2 = 52774
IR1 = 12211
IR2 = 3791
NTAB = 32
NDIV = (1+IMM1/NTAB)
EPS = 1.2e-7
RNMX = (1.0-EPS)

#[0, 1]乱数生成
def RandomNumber(idum)
	j = 0
	k = 0.to_f
    idum2 = 123456789
    iy = 0.to_f
    iv = Array.new(NTAB)
    temp = 0.to_f

	if (idum <= 0)
		if(-idum < 1)
			idum = 1
		else
			idum = - idum
		end

		#for (j = NTAB+7; j >= 0; j--) {
		(0..(NTAB+7)).reverse_each do |j|
			k = idum / IQ1
			idum = IA1 * ((idum) - k * IQ1) - k * IR1

			if (idum < 0)
				idum += IM1
			end

			if (j < NTAB)
				iv[j] = idum
			end
		end
		iy = iv[0]
	end

	k = idum / IQ1
	idum = IA1 * ((idum) - k * IQ1) - k * IR1

	if (idum < 0)
		idum += IM1
	end

	k = idum2 / IQ2
	idum2 = IA2 * (idum2 - k * IQ2) - k * IR2

	if(idum2 < 0)
        idum2 += IM2
    end

	j = iy / NDIV
	iy = iv[j] - idum2
	iv[j] = idum
	 
	if iy < 1
        iy += IMM1
    end

	if ((temp = AM * iy) > RNMX)
		return RNMX
	else
        return temp
    end
end
