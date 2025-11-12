function [N,C_b,C_s] = vUnit_gen(p,r,h,asp_rad,asp_h)
% p: complexity  r: radius; h: height; asp_rad: inner scale radius; asp_h:

%% nodal coordinates
            % p top internal, p bottom internal / p bottom external and p top external nodes

            Ang_dfl=pi/p;        % Deflection Angle
            N=[];
            N1=[];
            
            R = r*asp_rad;
            delta = h*asp_h;
            for i=1:p           % top internal
                N1_ni=[R*cos((2*Ang_dfl)*(i-1));R*sin((2*Ang_dfl)*(i-1));h];
                N1(:,i)= N1_ni;
            end

            N2=[];
            for i=1:p            % bottom internal
                N2_ni=[R*cos(Ang_dfl+(2*pi/p)*(i-1));R*sin(Ang_dfl+(2*pi/p)*(i-1));h-delta];
                N2(:,i)= N2_ni;
            end

            N3=[];
            for i=1:p            % bottom external
                N3_ni=[r*cos((2*Ang_dfl)*(i-1));r*sin((2*Ang_dfl)*(i-1));0];
                N3(:,i)= N3_ni;
            end

            N4=[];
            for i=1:p            % top external
                N4_ni=[r*cos(Ang_dfl+(2*pi/p)*(i-1));r*sin(Ang_dfl+(2*pi/p)*(i-1));2*h-delta];
                N4(:,i)= N4_ni;
            end

            N=[N1,N2,N3,N4];
            nn=size(N,2);


            %% Connectivity matrix of the structure

            C_b_in =[];             % bar connectivity

            for i=1:p       % from top internal to bottom external nodes
                c_b_in=[i 2*p+i];
                C_b_in=[C_b_in;c_b_in];
            end

            for i=p+1:2*p        % from bottom internal to top external nodes
                c_b_in=[i 2*p+i];
                C_b_in=[C_b_in;c_b_in];
            end

            for i=2*p+1:3*p       % top internal struts
                if i<3*p
                    c_b_in=[i-2*p i+1-2*p];
                    C_b_in=[C_b_in;c_b_in];
                else
                    c_b_in=[1 p];
                    C_b_in=[C_b_in;c_b_in];
                end
            end

            for i=3*p+1:4*p       % bottom internal struts
                if i<4*p
                    c_b_in=[i-2*p i+1-2*p];
                    C_b_in=[C_b_in;c_b_in];
                else
                    c_b_in=[p+1 2*p];
                    C_b_in=[C_b_in;c_b_in];
                end
            end

            C_s_in=[];           % string connectivity

            for i=1:p       % first half internal diagonal cables
                c_s_in=[i p+i];
                C_s_in=[C_s_in;c_s_in];
            end

            for i=p+1:2*p       % second half internal diagonal cables
                if i<2*p
                    c_s_in=[i-p+1 i];
                    C_s_in=[C_s_in;c_s_in];
                else
                    c_s_in=[1 2*p];
                    C_s_in=[C_s_in;c_s_in];
                end
            end

            for i=2*p+1:3*p       % top horizontal cables
                if i<3*p
                    c_s_in=[i+p p+i+1];
                    C_s_in=[C_s_in;c_s_in];
                else
                    c_s_in=[3*p+1 4*p];
                    C_s_in=[C_s_in;c_s_in];
                end
            end

            for i=3*p+1:4*p       % bottom horizontal cables
                if i<4*p
                    c_s_in=[i-p i-p+1];
                    C_s_in=[C_s_in;c_s_in];
                else
                    c_s_in=[2*p+1 3*p];
                    C_s_in=[C_s_in;c_s_in];
                end
            end

            for i=4*p+1:5*p       % first half external diagonal cables
                c_s_in=[i-2*p i-p];
                C_s_in=[C_s_in;c_s_in];
            end

            for i=5*p+1:6*p       % second half external diagonal cables
                if i<6*p
                    c_s_in=[i-3*p+1 i-2*p];
                    C_s_in=[C_s_in;c_s_in];
                else
                    c_s_in=[2*p+1 4*p];
                    C_s_in=[C_s_in;c_s_in];
                end
            end

            for i=6*p+1:7*p       % first half inner top cables
                c_s_in=[i-6*p i-3*p];
                C_s_in=[C_s_in;c_s_in];
            end

            for i=7*p+1:8*p       % second half inner top cables
                if i<8*p
                    c_s_in=[i-7*p+1 i-4*p];
                    C_s_in=[C_s_in;c_s_in];
                else
                    c_s_in=[1 4*p];
                    C_s_in=[C_s_in;c_s_in];
                end
            end

            for i=8*p+1:9*p       % first half inner bottom cables
                c_s_in=[i-7*p i-6*p];
                C_s_in=[C_s_in;c_s_in];
            end

            for i=9*p+1:10*p       % second half inner bottom cables
                if i<10*p
                    c_s_in=[i-8*p i-7*p+1];
                    C_s_in=[C_s_in;c_s_in];
                else
                    c_s_in=[2*p 2*p+1];
                    C_s_in=[C_s_in;c_s_in];
                end
            end


            C_b = tenseg_ind2C(C_b_in,N);
            C_s = tenseg_ind2C(C_s_in,N);


end