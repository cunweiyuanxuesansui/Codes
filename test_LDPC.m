%QC-LDPC
clear
clc
%
CodeLength=2304; 
CodeRate=1/2; 
[qcH,Hb]=QCLDPCBaseH(CodeLength,CodeRate);
[row,col]=size(qcH);
[rowb,colb]=size(Hb);
block=CodeLength/colb;
NewsLength=CodeRate*CodeLength;%
%
InputDataNum=100;
CodeNum=InputDataNum;
ITERNum= 20;
%%
data_origin = InputData;
data_LDPCcode=[];
data_LDPCencode = [];
data_encode_origin = [];
    snr=1;
    j=1;
    for i=1:CodeNum
        PerData=zeros(1,NewsLength);
        PerData(1,:)=InputData((j-1)*NewsLength+1:j*NewsLength);
        j=j+1;
        %
        PerCode=QCEncode(PerData,qcH,Hb); 
        data_LDPCcode = [data_LDPCcode,PerCode];
        SNR=10*(snr/10);
        sigma=sqrt(1/(2*CodeRate*SNR));
        ChannelNoise=(-(2*PerCode-1)); 
        OutputChannel=ChannelNoise;
        iternum=1;
        iter=ITERNum;
        BPOutputdecode=LDPCDecode(OutputChannel,rowb,colb,block,qcH,sigma,iter);
        data_LDPCencode = [data_LDPCencode,BPOutputdecode];       
        data_encode_origin = [data_encode_origin,BPOutputdecode(1+CodeLength*CodeRate*(iternum-1):...
            CodeLength*CodeRate+CodeLength*CodeRate*(iternum-1))];
    end
 sum(data_origin~=data_encode_origin)

csvwrite('Data_origin.csv',data_origin');  
S2P = reshape(data_origin,4,[]);
BitSeq_xu = S2P(1,:);
BitSeq_xv = S2P(2,:);
BitSeq_yu = S2P(3,:);
BitSeq_yv = S2P(4,:); 
%%
data_origin=[BitSeq_xu;BitSeq_xv;BitSeq_yu;BitSeq_yv];
data_origin=reshape(data_origin,1,[]);
csvwrite('Data_origin.csv',data_origin');   
%%
csvwrite('BitSeq_xu.csv',BitSeq_xu');
csvwrite('BitSeq_xv.csv',BitSeq_xv');
csvwrite('BitSeq_yu.csv',BitSeq_yu');     
csvwrite('BitSeq_yv.csv',BitSeq_yv');
%%
csvwrite('Data_origin_LDPCcode.csv',data_LDPCcode'); 
S2P = reshape(data_LDPCcode,4,[]);
BitSeq_xu = S2P(1,:);
BitSeq_xv = S2P(2,:);
BitSeq_yu = S2P(3,:);
BitSeq_yv = S2P(4,:); 
%% 
[BitSeq_xI,BitSeq_xQ] = dq_encoder(BitSeq_xu,BitSeq_xv);
[BitSeq_yI,BitSeq_yQ] = dq_encoder(BitSeq_yu,BitSeq_yv);
%%
csvwrite('BitSeq_xI.csv',BitSeq_xI');
csvwrite('BitSeq_xQ.csv',BitSeq_xQ');
csvwrite('BitSeq_yI.csv',BitSeq_yI');
csvwrite('BitSeq_yQ.csv',BitSeq_yQ');








