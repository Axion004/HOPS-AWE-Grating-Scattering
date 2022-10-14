function [xi_r_n_m,nu_r_n_m] = setup_xi_u_nu_u_n_m(A,r,xx,pp,...
    alpha_bar_p,gamma_bar_p,f,f_x,Nx,N,M)

% MSK 7/26/21: Changed the size of xi_r_n_m,nu_r_n_m from (Nx,N+1,M+1) to (Nx,M+1,N+1)

alpha_bar = alpha_bar_p(0+1);
gamma_bar = gamma_bar_p(0+1);
k_bar = sqrt(alpha_bar^2 + gamma_bar^2);

pp_r = pp(r+1);
alpha_bar_r = alpha_bar_p(r+1);
gamma_bar_r = gamma_bar_p(r+1);

% AWE approximation of gamma_q

gamma_r_m = gamma_exp(alpha_bar,alpha_bar_r,...
    gamma_bar,gamma_bar_r,k_bar,M);

% HOPS/AWE approximation of xi_q and nu_q

E_n_m = E_exp(gamma_r_m,f,N,M);
upper =  A*exp(1i*pp_r*xx);

xi_r_n_m = zeros(Nx,M+1,N+1);
nu_r_n_m = zeros(Nx,M+1,N+1);

for n=0:N
  for m=0:M
    xi_r_n_m(:,m+1,n+1) = upper.*E_n_m(:,m+1,n+1);
    for ell=0:m
      nu_r_n_m(:,m+1,n+1) = nu_r_n_m(:,m+1,n+1)...
          + (-1i*gamma_r_m(m-ell+1)).*xi_r_n_m(:,ell+1,n+1);
    end
    if(n>0)
      nu_r_n_m(:,m+1,n+1) = nu_r_n_m(:,m+1,n+1)...
          + f_x.*(1i*pp_r).*xi_r_n_m(:,m+1,n-1+1);
    end
  end
end

return;