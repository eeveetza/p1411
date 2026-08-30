% generate_reference_p1411.m
%
% Generates a CSV of reference input/output values for
% tl_p1411_belowroof, tl_p1411_aboveroof and tl_p1411_lowheight
%
%
% Only the deterministic branches are exercised (variations = false for
% the roof functions),

warning('off','all');

fid = fopen('reference_p1411.csv','w');
fprintf(fid,'func,type,x1,x2,p,w,L\n');

%% tl_p1411_belowroof(f, d, type, variations)
% x1 = f (GHz), x2 = d (m)

belowroof_cases = {
    1, [0.45 1 10 28 82 100 159 200 255 300], [5 20 100 300 500 250 250 150 155 100]
    2, [0.8 1 10 28 82 100 159],               [20 300 300 500 150 100 150]
    3, [0.45 1 10 28 73 100 159 200 255],       [10 100 150 150 150 100 80 50 50]
    4, [0.8 10 28 73],                          [30 100 100 170]
};

for c = 1:size(belowroof_cases,1)
    type = belowroof_cases{c,1};
    fvec = belowroof_cases{c,2};
    dvec = belowroof_cases{c,3};
    for i = 1:numel(fvec)
        f = fvec(i);
        d = dvec(i);
        L = tl_p1411_belowroof(f, d, type, false);
        fprintf(fid, 'belowroof,%d,%.10g,%.10g,,,%.10g\n', type, f, d, L);
    end
end

%% tl_p1411_aboveroof(f, d, type, variations)
% x1 = f (GHz), x2 = d (m)

aboveroof_cases = {
    1, [2.2 10 28 50 73],    [55 200 800 1000 1200]
    2, [2.2 10 28 50 66.5],  [260 500 800 1000 1200]
};

for c = 1:size(aboveroof_cases,1)
    type = aboveroof_cases{c,1};
    fvec = aboveroof_cases{c,2};
    dvec = aboveroof_cases{c,3};
    for i = 1:numel(fvec)
        f = fvec(i);
        d = dvec(i);
        L = tl_p1411_aboveroof(f, d, type, false);
        fprintf(fid, 'aboveroof,%d,%.10g,%.10g,,,%.10g\n', type, f, d, L);
    end
end

%% tl_p1411_lowheight(fMHz, dm, type, p, w)
% x1 = fMHz, x2 = dm (m)

fMHz_vec = [300 900 1800 2600 3000];
dm_vec   = [5 10 50 100 500 1000 2000];
p_vec    = [5 10 25 50 75 90 95];
type_vec = [1 2 3];
w_vec    = [20 30];

for type = type_vec
    for fMHz = fMHz_vec
        for dm = dm_vec
            for p = p_vec
                for w = w_vec
                    L = tl_p1411_lowheight(fMHz, dm, type, p, w);
                    fprintf(fid, 'lowheight,%d,%.10g,%.10g,%.10g,%.10g,%.10g\n', ...
                        type, fMHz, dm, p, w, L);
                end
            end
        end
    end
end

fclose(fid);

warning('on','all');

fprintf('Reference values written to reference_p1411.csv\n');
