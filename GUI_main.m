function varargout = GUI_main(varargin)
% GUI_main MATLAB code for the toolbox of photoacoustic imaging
%
%      H = GUI_main returns the handle to a new GUI_main or the handle to
%      the existing singleton*.
%
%      GUI_main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_main.M with the given input arguments.
%
%      GUI_main('Property','Value',...) creates a new GUI_main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI_main before GUI_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_main_OpeningFcn via varargin.
%
%      *See GUI_main Options on GUIDE's Tools menu.  Choose "GUI_main allows only one
%      instance to run (singleton)".
%
%    

% Begin initialization code 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_main_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_main_OutputFcn, ...
                   'gui_LayoutFcn',  @GUI_main_LayoutFcn, ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_main is made visible.
function GUI_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_main (see VARARGIN)

%%%%%%%%%%%%%%%%%%%%%  initialization  %%%%%%%%%%%%%%%%%%%%%
% ----------------- create multi tabs panel for display ---------------- %
handles.tgroup = uitabgroup('Parent', handles.uipanelTabs,'TabLocation', 'top','Units','Normalized');
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Forward result');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'Reconstruction result');
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'Spectra of coefficients');
% Place panels into each tab
set(handles.P1,'Parent',handles.tab1,'Units','Normalized')
set(handles.P2,'Parent',handles.tab2,'Units','Normalized')
set(handles.P3,'Parent',handles.tab3,'Units','Normalized')

% --------  add OA equation START--------------- %
axes(handles.axesFluenceEq)
I = imread('oa_equation.png');
imshow(I)
axis off

% --------  add OA equation END --------------- %
%set( findall( hObject, '-property', 'Units' ), 'Units', 'Normalized' )
% --------------  PARAMETERS ASSIGNMENT -------------------- % 
% set number of lasers and geo 
handles.numLasers = 5;
set(handles.editNumLaser, 'String', num2str(handles.numLasers))
set(handles.textContNumLaser, 'String', num2str(handles.numLasers))

dis1 = 20;
set(handles.editDis1, 'String', num2str(dis1))
set(handles.textContDis1, 'String', num2str(dis1))
handles.Vessel.pos = [0,dis1];  
handles.Laser1.pos = [0,0]; %(r,z) --> (x,y)
dis2 = 40;
set(handles.editDis2,'String', num2str(dis2))
set(handles.textContDis2, 'String', num2str(dis2))
handles.Laser2.pos = [dis2,0];
axes(handles.axesModel)
plot_geo(handles.Vessel.pos, [ handles.Laser1.pos; handles.Laser2.pos], handles.numLasers);

% set wav for the plot_fluence
set(handles.sliderWav ,'Value',700)
set(handles.textWav, 'String', num2str(700));

% set default mode: single forward
set(handles.radiobuttonSingleForward,'Value',1)
set(handles.radiobuttonForearm,'Value',1)
 
set(handles.editStOvRef, 'String', num2str(0.98)) % artery
set(handles.editTHbRef, 'String', num2str(0.117)) %  Jacques_PMB2013
set(handles.editStObRef, 'String', num2str(0.64))
set(handles.editCH2ORef, 'String', num2str(0.65)) % have not found this value
set(handles.editaRef, 'String', num2str(0.8))
set(handles.editbRef, 'String', num2str(0.2)) % a and b vary a lot, but this is reasonable.
set(handles.editNoiseLevel, 'String', num2str(0))  
set(handles.textContNoiseLevel, 'String', num2str(0))  
    
   
handles.StOv_range =  [get(handles.sliderStOv, 'Min') get(handles.sliderStOv, 'Max')];
handles.TCHb_range =  [get(handles.sliderTCHb, 'Min') get(handles.sliderTCHb, 'Max')];
handles.StOb_range =  [get(handles.sliderStOb, 'Min') get(handles.sliderStOb, 'Max')];
handles.CH2O_range =  [get(handles.sliderCH2O, 'Min') get(handles.sliderCH2O, 'Max')];
handles.CLipid_range =  [get(handles.sliderCLipid, 'Min') get(handles.sliderCLipid, 'Max')];
handles.a_range =  [get(handles.slidera, 'Min') get(handles.slidera, 'Max')];
handles.b_range =  [get(handles.sliderb, 'Min') get(handles.sliderb, 'Max')];
    
set(handles.textSliderStOvL, 'String', num2str(handles.StOv_range(1)));
set(handles.textSliderStOvH, 'String', num2str(handles.StOv_range(2)));
set(handles.textSliderTCHbL, 'String', num2str(handles.TCHb_range(1)));
set(handles.textSliderTCHbH, 'String', num2str(handles.TCHb_range(2)));
set(handles.textSliderStObL, 'String', num2str(handles.StOb_range(1)));
set(handles.textSliderStObH, 'String', num2str(handles.StOb_range(2)));
set(handles.textSliderCH2OL, 'String', num2str(handles.CH2O_range(1)));
set(handles.textSliderCH2OH, 'String', num2str(handles.CH2O_range(2)));
set(handles.textSliderCLipidL, 'String', num2str(handles.CLipid_range(1)));
set(handles.textSliderCLipidH, 'String', num2str(handles.CLipid_range(2)));
set(handles.textSlideraL, 'String', num2str(handles.a_range(1)));
set(handles.textSlideraH, 'String', num2str(handles.a_range(2)));
set(handles.textSliderbL, 'String', num2str(handles.b_range(1)));
set(handles.textSliderbH, 'String', num2str(handles.b_range(2)));
    
StOvCont =  0.8;
TCHbCont =  0.09;
StObCont =  0.8;
CH2OCont =  0.4;
CLipidCont =  0.2;
aCont =  0.65;
bCont =  0.2;
   
set(handles.sliderStOv, 'Value', StOvCont)
set(handles.sliderTCHb, 'Value', TCHbCont)
set(handles.sliderStOb, 'Value', StObCont)
set(handles.sliderCH2O, 'Value', CH2OCont)
set(handles.sliderCLipid, 'Value', CLipidCont) 
set(handles.slidera, 'Value', aCont)
set(handles.sliderb, 'Value', bCont)
    
set(handles.textStOvCont, 'String', num2str(StOvCont,3))
set(handles.textTCHbCont, 'String', num2str(TCHbCont,3))
set(handles.textStObCont, 'String', num2str(StObCont,3))
set(handles.textCH2OCont, 'String', num2str(CH2OCont,3))
set(handles.textCLipidCont, 'String', num2str(CLipidCont,3))
set(handles.textaCont, 'String', num2str(aCont,3))
set(handles.textbCont, 'String', num2str(bCont,3))
         
set(handles.editStOvInit, 'String', num2str(StOvCont,3))
set(handles.editTCHbInit, 'String', num2str(TCHbCont,3));
set(handles.editStObInit, 'String', num2str(StObCont,3));
set(handles.editCH2OInit, 'String',  num2str(CH2OCont,3));
set(handles.editCLipidInit, 'String' , num2str(CLipidCont,3));
set(handles.editaInit, 'String', num2str(aCont,3));
set(handles.editbInit, 'String', num2str(bCont,3));
% --------------  PARAMETERS ASSIGNMENT END ---------------- % 
%%%%%%%%%%%%%%%%%%%% initialization end %%%%%%%%%%%%%%%%%%%
% Choose default command line output for GUI_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ----------------  plot_geo START-----------------%
handles.numLasers = str2double(get(handles.editNumLaser, 'String'));
set(handles.textContNumLaser, 'String', num2str(handles.numLasers))
if handles.numLasers == 1
    dis1 = str2double(get(handles.editDis1, 'String'));
    set(handles.textContDis1,'String', num2str(dis1));
    handles.Vessel.pos = [0,dis1]; 
    axes(handles.axesModel)
    plot_geo(handles.Vessel.pos, handles.Laser1.pos,1);
else
    dis1 = str2double(get(handles.editDis1, 'String'));
    set(handles.textContDis1,'String', num2str(dis1));
    handles.Vessel.pos = [0,dis1];  
    % handles.Laser1.pos = [0,0]; %(r,z) --> (x,y)
    dis2 = str2double(get(handles.editDis2,'String'));
    set(handles.textContDis2, 'String', num2str(dis2))
    handles.Laser2.pos = [dis2,0];
    axes(handles.axesModel)
    plot_geo(handles.Vessel.pos, [ handles.Laser1.pos; handles.Laser2.pos], handles.numLasers);

end
% ----------------  plot_geo END-----------------%

if get(handles.radiobuttonSingleForward,'Value') == 1
     
    
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
    % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.ref.wavList = handles.wavList;
    handles.ref.StOv = str2double(get(handles.editStOvRef, 'String'));
    handles.ref.TCHb = str2double(get(handles.editTHbRef, 'String'));
    handles.ref.StOb = str2double(get(handles.editStObRef, 'String'));
    
    handles.ref.COHb = handles.ref.TCHb * handles.ref.StOb;
    handles.ref.CHHb = handles.ref.TCHb - handles.ref.COHb;
   
    handles.ref.CH2O = str2double(get(handles.editCH2ORef, 'String'));
    handles.ref.CLipid = str2double(get(handles.editCLipidRef, 'String'));
    handles.ref.a = str2double(get(handles.editaRef, 'String'));
    handles.ref.b = str2double(get(handles.editbRef, 'String'));
    handles.NoiseLevel = 0.01*str2double(get(handles.editNoiseLevel, 'String'));
    set(handles.textContNoiseLevel, 'String', num2str(100*handles.NoiseLevel));
    % range of noise level = [0, 10]
    if handles.NoiseLevel > 0.1
        handles.NoiseLevel = 0.1;
    end
    handles.ref.vesselpos = handles.Vessel.pos;
    handles.ref.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.ref.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    
%     % ----loop over wavs to find the max and min fluence and  mua_vessel ---%
%     [handles.MaxFluence, handles.MinFluence] = get_MaxMinFluence(handles.ref);
%     [handles.MaxMuaVessel, handles.MinMuaVessel] = get_MaxMinMuaVessel(handles.ref);
%     
%     % -------------------- max and min end ------------------------------%
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
        handles.plotF = handles.ref;
        handles.plotF.wav = get(handles.sliderWav, 'Value');
        handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
        plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------%
    
    % -----------------  Single Forward Start ------------------- %
    if isfield(handles.ref, 'NoiseLevel')
    handles.ref = rmfield(handles.ref,'NoiseLevel');
    end
    handles.ref.ForwardResult = forwardFcn(handles.ref);
    
        % generate noisy result
    handles.ref.NoiseLevel = handles.NoiseLevel;
    handles.ref.rDataRefNoise =  forwardFcn(handles.ref);

    % -----------------  Single Forward End --------------------- %

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
%      plot(handles.ref.ForwardResult,'-ob')
%     hold on
%     plot(handles.ref.rDataRefNoise,'-*r')
   semilogy(handles.ref.ForwardResult,'-ob')
    hold on
    semilogy(handles.ref.rDataRefNoise,'-*r')
     
    legend('reference signal','noisy signal')
    ylabel('value')
    xlabel('data index')
    % ------------------  DISPLAY RESULT END ---------------------%
    
 %----------------- plot mu - C_chromophores ---------------------%
 if get(handles.radiobuttonPlotMuaC,'Value') == 1
%      axes(handles.axesPlotMuC1)
    plot_mu_C_chromophores(handles.ref,...
        handles.axesPlotMuC1,...
        handles.axesPlotMuC2,...
        handles.axesPlotMuC3)
    
    
% plot_ultra(handles.ref);
 end
%---------------  plot mu - C_chromophores END -------------------%

%---------------- plot Ultrasound Signal -------------------------%
    if get(handles.radiobuttonPlotUltraSignal, 'Value') == 1
        axes(handles.axesUltra)
        plot_ultra(handles.ref);
    end
%---------------- plot Ultrasound Signal END ---------------------%


elseif get(handles.radiobuttonContForward,'Value') == 1
    %%%%%%%%%%%%%%%%%%%%%%%  Continuous mode STARR %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
    % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.cont.wavList = handles.wavList;
    handles.cont.StOv = get(handles.sliderStOv, 'Value');
    
    handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
    handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    
    handles.cont.CH2O = get(handles.sliderCH2O, 'Value');
    handles.cont.CLipid = get(handles.sliderCLipid, 'value');
    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
    handles.cont.b = get(handles.sliderb, 'Value');

    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav = get(handles.sliderWav, 'Value');
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------%
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);
    
    
    % -----------------  Cont Forward End --------------------- %
    

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
        hold on
        ylabel('value')
        xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
            legend('manual fitting', 'reference', 'noisy reference')
        else
            plot(handles.cont.ForwardResult,'-oc')
            %%plot(handles.cont.ForwardResult+noise,'-*r')
     
            legend('manual fitting')
            
        end
         
    if get(handles.radiobuttonPlotUltraSignal, 'Value') == 1
        axes(handles.axesUltra)
        plot_ultra(handles.cont);
    end

 %%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
 
elseif  get(handles.radiobuttonRec,'Value') == 1
     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
        % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.init.wavList = handles.wavList;
    handles.init.StOv = str2double(get(handles.editStOvInit, 'String'));
    
    handles.init.TCHb = str2double(get(handles.editTCHbInit, 'String'));
    handles.init.StOb = str2double(get(handles.editStObInit, 'String'));
    handles.init.COHb = handles.init.TCHb * handles.init.StOb;
    handles.init.CHHb = handles.init.TCHb - handles.init.COHb;
    handles.init.CH2O = str2double(get(handles.editCH2OInit, 'String'));
    handles.init.CLipid = str2double(get(handles.editCLipidInit, 'String'));
    handles.init.a = str2double(get(handles.editaInit, 'String'));
    handles.init.b = str2double(get(handles.editbInit, 'String'));
 
    handles.init.vesselpos = handles.Vessel.pos;
    handles.init.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.init.numLasers = handles.numLasers;
    
    handles.init.StOv_range = handles.StOv_range;
    handles.init.TCHb_range = handles.TCHb_range;
    handles.init.StOb_range =  handles.StOb_range;
    handles.init.CH2O_range =  handles.CH2O_range;
    handles.init.CLipid_range =   handles.CLipid_range ;
    handles.init.a_range = handles.a_range;
    handles.init.b_range =  handles.b_range;
    
    handles.init.CHHb_range = handles.TCHb_range .* (1-fliplr(handles.StOb_range));
    handles.init.COHb_range = handles.TCHb_range .* handles.StOb_range;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    
    % ---------------FOrward for init -------------------------- %
      handles.init.RatioResult = forwardFcn(handles.init);
    % --------------- FOrward for init end ----------------------%
    
    % ----------------- RECONSTRUCTION START ------------------- %
   if isfield(handles, 'ref')
  
%       % get scaling factor 
%             if handles.numLasers > 1
%                 numWav = 27;    
%                 factor_scl = ones(1,numWav).*mean(handles.ref.ForwardResult(1:numWav));
%                 for jj = 2:handles.numLasers
%                      
%                     factor_scl((jj - 1)* numWav  + 1 :jj * numWav  ) = ...
%                     ones(1,numWav ) .* ...
%                     mean(handles.ref.ForwardResult((jj - 1)*numWav + 1 :jj *numWav )) ./ ...
%                     mean(handles.ref.ForwardResult(1:numWav ));
%                      
%                 end
%             else
%                 factor_scl = ones(1,27);
%             end
%    
%     handles.init.fac_scl = factor_scl;        
    handles.recResult = reconstructionFcn(handles.init, handles.ref.rDataRefNoise); % noisy reference forward result
    handles.rec.StOv = handles.recResult(5); 
    handles.rec.CHHb = handles.recResult(1)/100; % it is actually a* CHHb
    handles.rec.COHb = handles.recResult(2)/10;  % a* COHb
    handles.rec.CH2O = handles.recResult(3); % a* CH2O
    handles.rec.CLipid = handles.recResult(4);
    handles.rec.a = 1; % for forward result 
    handles.rec.b = handles.recResult(6);
    handles.rec.StOb = handles.rec.COHb/ (handles.rec.COHb + handles.rec.CHHb);
    

   else
%        errorMSG = 'please generate reference forward result first before reconstruction !';
%        error(errorMSG)
        msgbox('Oops! No reference data available. Could you generate forward result first, please?');
        
   end
    % ------------------- RECONSTRUCTION END ------------------- %
    
    % ---------------- DISPLAY RECONSTRUCTION RESULT ------------%
    a = handles.init.a;
    init = [a* handles.init.CHHb * 100,...
            a* handles.init.COHb * 10, ...
            a* handles.init.CH2O,...
            a* handles.init.CLipid,...
            handles.init.StOv, ...     
            handles.init.b];
     a = handles.ref.a;   
     ref = [a* handles.ref.CHHb * 100,...
            a* handles.ref.COHb * 10, ...
            a* handles.ref.CH2O,...
            a* handles.ref.CLipid,...
            handles.ref.StOv, ...
            handles.ref.b];
      axes(handles.axesRecResult)
      
      plot(handles.recResult,'ob', 'MarkerSize',10)
      hold on
      plot(ref,'*g', 'MarkerSize',10)
      plot(init,'rx', 'MarkerSize',10)
      legend('reconstruction', 'reference', 'initial guess','Location','northwest')
      Labels = {'a*C_{HHb}b', 'a*C_{OHb}b', 'a*C_{H2O}b', 'a*C_{Lipid}b','StOv', 'b'};
      set(gca, 'XTick', [1:6], 'XTickLabel', Labels);
      ylabel('value')
      xlabel('parameters')
      hold off
       
      axes(handles.axesRecStO)
      cla
      Labels = {'Reconstructed StOv'};
      set(gca, 'XTick', 1, 'XTickLabel', Labels);
      ymax = 1;
      ymin = 0.3;
      hold on
      plot([0:2],handles.ref.StOv*ones(size([0:2])),'--g','LineWidth',3);
      plot([0:2],handles.init.StOv*ones(size([0:2])),'--r','LineWidth',3);
      ylim([ymin ,ymax])
      set(gca,'ytick',[ymin:0.05:ymax]);
      bar(handles.rec.StOv, 'BaseValue', ymin, 'FaceAlpha',.3,'EdgeAlpha',.3);
%       text(1,handles.rec.StOv,1,num2str(handles.rec.StOv),'HorizontalAlignment','right','Color','k')
title(['rec = ' num2str(handles.rec.StOv,3)])
     %%% plot oxy for the bulk
       axes(handles.axesRecStOBulk)
       cla
       Labels = {'Reconstructed StOb'};
       set(gca, 'XTick', 1, 'XTickLabel', Labels);
       ymax = 1;
       ymin = 0.3;
       hold on
       plot([0:2],handles.ref.StOb*ones(size([0:2])),'--g','LineWidth',3);
       hold on
       plot([0:2],handles.init.StOb*ones(size([0:2])),'--r','LineWidth',3);
       ylim([ymin ,ymax])
       set(gca,'ytick',[ymin:0.05:ymax]);
       bar(handles.rec.StOb, 'BaseValue', ymin,'FaceAlpha',.3,'EdgeAlpha',.3);
 title(['rec = ' num2str(handles.rec.StOb,3)])

       % display forward result for reconstructed values
       % --------------  PARAMETERS ASSIGNMENT -------------------- % 
       handles.rec.vesselpos = handles.Vessel.pos;
       handles.rec.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
       handles.rec.numLasers = handles.numLasers;
       % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
       % -----------------   Forward for rec Start ------------------- %
       handles.rec.RatioResult = forwardFcn(handles.rec);
       % -----------------  Forward for rec End --------------------- %
       % ----- plot forward result ----------------- % 
       axes(handles.axesForwardResult)
       cla
       hold on
       ylabel('value')
       xlabel('data index')
       plot(handles.init.RatioResult,'-oc')
       plot(handles.ref.ForwardResult,'-ob')
       plot(handles.ref.rDataRefNoise,'-*r')
       plot(handles.rec.RatioResult, '-*k')

       legend('initial', 'reference', 'noisy reference', 'reconstructed')   

% %         if  isfield(handles.init, 'fac_scl')
%             plot(handles.init.RatioResult./handles.init.fac_scl,'-oc')
%            plot(handles.ref.ForwardResult./handles.init.fac_scl,'-ob')
%            plot(handles.ref.rDataRefNoise./handles.init.fac_scl,'-*r')
%            plot(handles.rec.RatioResult./handles.init.fac_scl, '-*k')
% 
%            legend('initial', 'reference', 'noisy reference', 'reconstructed')
%     %       title('scaled ratio data') 
%         
%        end
    % ---------------- DISPLAY RECONSTRUCTION RESULT END---------%
    
else
    errorMSG = 'Please select a mode';
    error(errorMSG)
 
end

guidata(hObject, handles);


function editStOvRef_Callback(hObject, eventdata, handles)
% hObject    handle to editStOvRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStOvRef as text
%        str2double(get(hObject,'String')) returns contents of editStOvRef as a double


% --- Executes during object creation, after setting all properties.
function editStOvRef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStOvRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderStOv_Callback(hObject, eventdata, handles)
% hObject    handle to sliderStOv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% get value from slider
handles.cont.StOv = get(hObject, 'Value');
set(handles.textStOvCont, 'String', num2str(handles.cont.StOv,3));
set(handles.editStOvInit, 'String', num2str(handles.cont.StOv,3));
if get(handles.radiobuttonContForward,'Value') == 1
     
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode START %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
        % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.cont.wavList = handles.wavList;
%     handles.cont.StOv = get(handles.sliderStOv, 'Value');
    handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
    handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    handles.cont.CH2O = get(handles.sliderCH2O, 'value');
    handles.cont.CLipid = get(handles.sliderCLipid, 'value');
    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
    handles.cont.b = get(handles.sliderb, 'Value');

    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
        
        handles.plotF = handles.cont;
        handles.plotF.wav = get(handles.sliderWav, 'Value');
        handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
    %         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
        plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------% 
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);
    % -----------------  Cont Forward End --------------------- %
    
    %---------------- plot Ultrasound Signal -------------------------%
    if get(handles.radiobuttonPlotUltraSignal, 'Value') == 1
        axes(handles.axesUltra)
        plot_ultra(handles.cont);
    end
%---------------- plot Ultrasound Signal END ---------------------%

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
         cla
        hold on
            ylabel('value')
    xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
             
            
            legend('manual fitting', 'reference', 'noisy reference')
             
        else
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.cont.ForwardResult+noise,'-*b')
     
            legend('manual fitting')
             
        end
        
    % --------------------- DISPLAY RESULT END ------------------%
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
end


guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderStOv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderStOv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editStOvInit_Callback(hObject, eventdata, handles)
% hObject    handle to editStOvInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStOvInit as text
%        str2double(get(hObject,'String')) returns contents of editStOvInit as a double


% --- Executes during object creation, after setting all properties.
function editStOvInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStOvInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTHbRef_Callback(hObject, eventdata, handles)
% hObject    handle to editTHbRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTHbRef as text
%        str2double(get(hObject,'String')) returns contents of editTHbRef as a double


% --- Executes during object creation, after setting all properties.
function editTHbRef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTHbRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editStObRef_Callback(hObject, eventdata, handles)
% hObject    handle to editStObRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStObRef as text
%        str2double(get(hObject,'String')) returns contents of editStObRef as a double


% --- Executes during object creation, after setting all properties.
function editStObRef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStObRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editaRef_Callback(hObject, eventdata, handles)
% hObject    handle to editaRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editaRef as text
%        str2double(get(hObject,'String')) returns contents of editaRef as a double


% --- Executes during object creation, after setting all properties.
function editaRef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editaRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editbRef_Callback(hObject, eventdata, handles)
% hObject    handle to editbRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbRef as text
%        str2double(get(hObject,'String')) returns contents of editbRef as a double


% --- Executes during object creation, after setting all properties.
function editbRef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNoiseLevel_Callback(hObject, eventdata, handles)
% hObject    handle to editNoiseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNoiseLevel as text
%        str2double(get(hObject,'String')) returns contents of editNoiseLevel as a double


% --- Executes during object creation, after setting all properties.
function editNoiseLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNoiseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to sliderStOv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderStOv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderTCHb_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTCHb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


handles.cont.TCHb = get(hObject, 'Value');
set(handles.textTCHbCont, 'String', num2str(handles.cont.TCHb,3));
set(handles.editTCHbInit, 'String', num2str(handles.cont.TCHb,3));
if get(handles.radiobuttonContForward,'Value') == 1
     
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode START %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
    % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.cont.wavList = handles.wavList;
    handles.cont.StOv = get(handles.sliderStOv, 'Value');
%     handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
    handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    handles.cont.CH2O = get(handles.sliderCH2O, 'value');
    handles.cont.CLipid = get(handles.sliderCLipid, 'value');
    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
    handles.cont.b = get(handles.sliderb, 'Value');
    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav = get(handles.sliderWav, 'Value');
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
  %         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------% 
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);
    
   
    % -----------------  Cont Forward End --------------------- %
        %---------------- plot Ultrasound Signal -------------------------%
    if get(handles.radiobuttonPlotUltraSignal, 'Value') == 1
        axes(handles.axesUltra)
        plot_ultra(handles.cont);
    end
%---------------- plot Ultrasound Signal END ---------------------%


    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
        hold on
            ylabel('value')
    xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
             
            
            legend('manual fitting', 'reference', 'noisy reference')
        else
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.cont.ForwardResult+noise,'-*b')
     
            legend('manual fitting')
        end
        
    % --------------------- DISPLAY RESULT END ------------------%
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderTCHb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTCHb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderStOb_Callback(hObject, eventdata, handles)
% hObject    handle to sliderStOb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.cont.StOb = get(hObject, 'Value');
set(handles.textStObCont, 'String', num2str(handles.cont.StOb,3));
set(handles.editStObInit, 'String', num2str(handles.cont.StOb,3));

if get(handles.radiobuttonContForward,'Value') == 1
     
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode STARR %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
    % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.cont.wavList = handles.wavList;
    handles.cont.StOv = get(handles.sliderStOv, 'Value');
    handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
%     handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    handles.cont.CH2O = get(handles.sliderCH2O, 'value');
    handles.cont.CLipid = get(handles.sliderCLipid, 'value');
    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
    handles.cont.b = get(handles.sliderb, 'Value');
    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.numLasers = handles.numLasers;
    if handles.numLasers == 1;
        handles.cont.laserpos = [handles.Laser1.pos] ;
    else
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    end
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav = get(handles.sliderWav, 'Value');
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------% 
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);
        
    % -----------------  Cont Forward End --------------------- %
    
        %---------------- plot Ultrasound Signal -------------------------%
    if get(handles.radiobuttonPlotUltraSignal, 'Value') == 1
        axes(handles.axesUltra)
        plot_ultra(handles.cont);
    end
%---------------- plot Ultrasound Signal END ---------------------%

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
        hold on
            ylabel('value')
    xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
             
            
            legend('manual fitting', 'reference', 'noisy reference')
        else
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.cont.ForwardResult+noise,'-*b')
     
            legend('manual fitting')
        end
        
    % --------------------- DISPLAY RESULT END ------------------%
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
end
    
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderStOb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderStOb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editTCHbInit_Callback(hObject, eventdata, handles)
% hObject    handle to editTCHbInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTCHbInit as text
%        str2double(get(hObject,'String')) returns contents of editTCHbInit as a double


% --- Executes during object creation, after setting all properties.
function editTCHbInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTCHbInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editStObInit_Callback(hObject, eventdata, handles)
% hObject    handle to editStObInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStObInit as text
%        str2double(get(hObject,'String')) returns contents of editStObInit as a double


% --- Executes during object creation, after setting all properties.
function editStObInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStObInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editaInit_Callback(hObject, eventdata, handles)
% hObject    handle to editaInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editaInit as text
%        str2double(get(hObject,'String')) returns contents of editaInit as a double


% --- Executes during object creation, after setting all properties.
function editaInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editaInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editbInit_Callback(hObject, eventdata, handles)
% hObject    handle to editbInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbInit as text
%        str2double(get(hObject,'String')) returns contents of editbInit as a double


% --- Executes during object creation, after setting all properties.
function editbInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editaCont_Callback(hObject, eventdata, handles)
% hObject    handle to editaCont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editaCont as text
%        str2double(get(hObject,'String')) returns contents of editaCont as a double


% --- Executes during object creation, after setting all properties.
function editaCont_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editaCont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editbCont_Callback(hObject, eventdata, handles)
% hObject    handle to editbCont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbCont as text
%        str2double(get(hObject,'String')) returns contents of editbCont as a double


% --- Executes during object creation, after setting all properties.
function editbCont_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbCont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slidera_Callback(hObject, eventdata, handles)
% hObject    handle to slidera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.cont.a = get(hObject, 'Value');
set(handles.textaCont, 'String', num2str(handles.cont.a,3));
set(handles.editaInit, 'String', num2str(handles.cont.a,3));
if get(handles.radiobuttonContForward,'Value') == 1
     
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode STARR %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
    % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.cont.wavList = handles.wavList;
    handles.cont.StOv = get(handles.sliderStOv, 'Value');
  handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
    handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    handles.cont.CH2O = get(handles.sliderCH2O, 'value');
    handles.cont.CLipid = get(handles.sliderCLipid, 'value');

    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
    handles.cont.b = get(handles.sliderb, 'Value');
    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav = get(handles.sliderWav, 'Value');
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------% 
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);
    
%         % generate noisy result
   % -----------------  Cont Forward End --------------------- %
    
    %---------------- plot Ultrasound Signal -------------------------%
    if get(handles.radiobuttonPlotUltraSignal, 'Value') == 1
        axes(handles.axesUltra)
        plot_ultra(handles.cont);
    end
%---------------- plot Ultrasound Signal END ---------------------%

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
        hold on
            ylabel('value')
    xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
             
            
            legend('manual fitting', 'reference', 'noisy reference')
        else
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.cont.ForwardResult+noise,'-*b')
     
            legend('manual fitting')
        end
      
    % --------------------- DISPLAY RESULT END ------------------%
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
end


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slidera_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slidera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderb_Callback(hObject, eventdata, handles)
% hObject    handle to sliderb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.cont.b = get(hObject, 'Value');
set(handles.textbCont, 'String', num2str(handles.cont.b,3));
set(handles.editbInit, 'String', num2str(handles.cont.b,3));
if get(handles.radiobuttonContForward,'Value') == 1
     
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode STARR %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
        % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.cont.wavList = handles.wavList;
    handles.cont.StOv = get(handles.sliderStOv, 'Value');
    handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
    handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    handles.cont.CH2O = get(handles.sliderCH2O, 'value');
    handles.cont.CLipid = get(handles.sliderCLipid, 'value');

    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
%     handles.cont.b = get(handles.sliderb, 'Value');

    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav = get(handles.sliderWav, 'Value');
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------% 
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);
       
    % -----------------  Cont Forward End --------------------- %
    
    %---------------- plot Ultrasound Signal -------------------------%
    if get(handles.radiobuttonPlotUltraSignal, 'Value') == 1
        axes(handles.axesUltra)
        plot_ultra(handles.cont);
    end
%---------------- plot Ultrasound Signal END ---------------------%

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
        hold on
            ylabel('value')
    xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
             
            
            legend('manual fitting', 'reference', 'noisy reference')
        else
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.cont.ForwardResult+noise,'-*b')
     
            legend('manual fitting')
        end
      
    % --------------------- DISPLAY RESULT END ------------------%
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
end


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sliderb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editCH2ORef_Callback(hObject, eventdata, handles)
% hObject    handle to editCH2ORef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCH2ORef as text
%        str2double(get(hObject,'String')) returns contents of editCH2ORef as a double


% --- Executes during object creation, after setting all properties.
function editCH2ORef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCH2ORef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderCH2O_Callback(hObject, eventdata, handles)
% hObject    handle to sliderCH2O (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.cont.CH2O = get(hObject, 'Value');
set(handles.textCH2OCont, 'String', num2str(handles.cont.CH2O,3));
set(handles.editCH2OInit, 'String', num2str(handles.cont.CH2O,3));
if get(handles.radiobuttonContForward,'Value') == 1
     
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode STARR %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
    % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END ----------------%
    handles.cont.wavList = handles.wavList;
    handles.cont.StOv = get(handles.sliderStOv, 'Value');
    handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
    handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    handles.cont.CH2O = get(handles.sliderCH2O, 'value');
    handles.cont.CLipid = get(handles.sliderCLipid, 'value');

    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
    handles.cont.b = get(handles.sliderb, 'Value');

    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav = get(handles.sliderWav, 'Value');
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------% 
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);
  
    % -----------------  Cont Forward End --------------------- %
    

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
        hold on
            ylabel('value')
    xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
             
            
            legend('manual fitting', 'reference', 'noisy reference')
        else
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.cont.ForwardResult+noise,'-*b')
     
            legend('manual fitting')
        end
         
    % --------------------- DISPLAY RESULT END ------------------%
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
end


guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderCH2O_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderCH2O (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editCH2OInit_Callback(hObject, eventdata, handles)
% hObject    handle to editCH2OInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCH2OInit as text
%        str2double(get(hObject,'String')) returns contents of editCH2OInit as a double


% --- Executes during object creation, after setting all properties.
function editCH2OInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCH2OInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function sliderCLipid_Callback(hObject, eventdata, handles)
% hObject    handle to sliderCH2O (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.cont.CLipid = get(hObject, 'Value');
set(handles.textCLipidCont, 'String', num2str(handles.cont.CLipid,3));
set(handles.editCLipidInit, 'String', num2str(handles.cont.CLipid,3));
if get(handles.radiobuttonContForward,'Value') == 1
     
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode STARR %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
        % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.cont.wavList = handles.wavList;
    handles.cont.StOv = get(handles.sliderStOv, 'Value');
    handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
    handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    handles.cont.CH2O = get(handles.sliderCH2O, 'value');
%     handles.cont.CLipid = get(handles.sliderCLipid, 'value');

    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
    handles.cont.b = get(handles.sliderb, 'Value');

    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
    
    % ----------------- plot fluence START ------------------%
    if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav = get(handles.sliderWav, 'Value');
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF)
    end
    % ----------------- plot fluence END ------------------% 
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);
    
    % -----------------  Cont Forward End --------------------- %
    

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
        hold on
            ylabel('value')
    xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
             
            
            legend('manual fitting', 'reference', 'noisy reference')
        else
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.cont.ForwardResult+noise,'-*b')
     
            legend('manual fitting')
        end
         
    % --------------------- DISPLAY RESULT END ------------------%
%%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
end


guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderCLipid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderCH2O (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editCLipidInit_Callback(hObject, eventdata, handles)
% hObject    handle to editCH2OInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCH2OInit as text
%        str2double(get(hObject,'String')) returns contents of editCH2OInit as a double


% --- Executes during object creation, after setting all properties.
function editCLipidInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCH2OInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editDis1_Callback(hObject, eventdata, handles)
% hObject    handle to editDis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDis1 as text
%        str2double(get(hObject,'String')) returns contents of editDis1 as a double


% ----------------  plot_geo START-----------------%
handles.numLasers = str2double(get(handles.editNumLaser, 'String'));
set(handles.textContNumLaser, 'String', num2str(handles.numLasers))
if handles.numLasers == 1
    dis1 = str2double(get(handles.editDis1, 'String'));
    if dis1 >60
        dis1 = 60;
        set(handles.editDis1,'String',60);
    end
    if dis1<0
        dis1 = 0;
        set(handles.editDis1,'String',0);
    end
    set(handles.textContDis1,'String', num2str(dis1));
    handles.Vessel.pos = [0,dis1]; 
    axes(handles.axesModel)
    plot_geo(handles.Vessel.pos, handles.Laser1.pos,1);
else
    dis1 = str2double(get(handles.editDis1, 'String'));
    if dis1 >60
        dis1 = 60;
        set(handles.editDis1,'String',60);
    end
    if dis1<0
        dis1 = 0;
        set(handles.editDis1,'String',0);
    end
    set(handles.textContDis1,'String', num2str(dis1));
    handles.Vessel.pos = [0,dis1];  
    % handles.Laser1.pos = [0,0]; %(r,z) --> (x,y)
     
    dis2 = str2double(get(handles.editDis2,'String'));
%     if dis2 > 45
%         dis2 = 45;
%         set(handles.editDis2,'String',dis2);
%     end
%     if dis2 < -45
%         dis2 = -45;
%         set(handles.editDis2,'String',dis2);
%     end
    set(handles.textContDis2, 'String', num2str(dis2))
    handles.Laser2.pos = [dis2,0];
    axes(handles.axesModel)
    plot_geo(handles.Vessel.pos, [ handles.Laser1.pos; handles.Laser2.pos], handles.numLasers);

end
% ----------------  plot_geo END-----------------%



guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editDis1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDis2_Callback(hObject, eventdata, handles)
% hObject    handle to editDis2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDis2 as text
%        str2double(get(hObject,'String')) returns contents of editDis2 as a double

% ----------------  plot_geo START-----------------%
handles.numLasers = str2double(get(handles.editNumLaser, 'String'));
set(handles.textContNumLaser, 'String', num2str(handles.numLasers))
if handles.numLasers == 1
    dis1 = str2double(get(handles.editDis1, 'String'));
    set(handles.textContDis1,'String', num2str(dis1));
    handles.Vessel.pos = [0,dis1]; 
    axes(handles.axesModel)
    plot_geo(handles.Vessel.pos, handles.Laser1.pos,1);
else
    dis1 = str2double(get(handles.editDis1, 'String'));
    set(handles.textContDis1,'String', num2str(dis1));
    handles.Vessel.pos = [0,dis1];  
    % handles.Laser1.pos = [0,0]; %(r,z) --> (x,y)
    dis2 = str2double(get(handles.editDis2,'String'));
    if dis2 > 45
        dis2 = 45;
        set(handles.editDis2,'String',dis2);
    end
    if dis2 < -45
        dis2 = -45;
        set(handles.editDis2,'String',dis2);
    end
    set(handles.textContDis2, 'String', num2str(dis2))
    handles.Laser2.pos = [dis2,0];
    axes(handles.axesModel)
    plot_geo(handles.Vessel.pos, [ handles.Laser1.pos; handles.Laser2.pos], handles.numLasers);

end
% ----------------  plot_geo END-----------------%
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editDis2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDis2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderWav_Callback(hObject, eventdata, handles)
% hObject    handle to sliderWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.wav = get(handles.sliderWav, 'Value');
set(handles.textWav,'String', handles.wav)
if get(handles.radiobuttonSingleForward, 'Value') == 1
% ----------------- plot fluence START ------------------%
     if get(handles.radiobuttonPlotFluence, 'Value') == 1
         handles.plotF = handles.ref; 
        handles.plotF.wav =  handles.wav;
        handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
        % for audio volume
            temp_sig = handles.ref.ForwardResult(1:27);
             handles.plotF.max_sig = max(temp_sig);
             handles.plotF.min_sig = min(temp_sig);
            
           handles.plotF.isSliderWav = 1; 
    %         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
        plot_fluence(handles.plotF)
     end

         
      
    % ----------------- plot fluence END ------------------% 
elseif get(handles.radiobuttonContForward,'Value') == 1
% ----------------- plot fluence START ------------------%
if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav =  handles.wav;
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
    handles.plotF.isSliderWav = 1;
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF) 
end
    % ----------------- plot fluence END ------------------% 

end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderWav_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editNumLaser_Callback(hObject, eventdata, handles)
% hObject    handle to editNumLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumLaser as text
%        str2double(get(hObject,'String')) returns contents of editNumLaser as a double
% ----------------  plot_geo START-----------------%
handles.numLasers = str2double(get(handles.editNumLaser, 'String'));
 
set(handles.textContNumLaser, 'String', num2str(handles.numLasers))
if handles.numLasers < 1
    handles.numLasers = 1;
    set(handles.editNumLaser, 'String','1')
    set(handles.textContNumLaser, 'String', num2str(handles.numLasers))
elseif handles.numLasers == 1
    dis1 = str2double(get(handles.editDis1, 'String'));
    set(handles.textContDis1,'String', num2str(dis1));
    handles.Vessel.pos = [0,dis1]; 
    axes(handles.axesModel)
    plot_geo(handles.Vessel.pos, handles.Laser1.pos,1);
else
    dis1 = str2double(get(handles.editDis1, 'String'));
    set(handles.textContDis1,'String', num2str(dis1));
    handles.Vessel.pos = [0,dis1];  
    % handles.Laser1.pos = [0,0]; %(r,z) --> (x,y)
    dis2 = str2double(get(handles.editDis2,'String'));
    set(handles.textContDis2, 'String', num2str(dis2))
    handles.Laser2.pos = [dis2,0];
    axes(handles.axesModel)
    plot_geo(handles.Vessel.pos, [ handles.Laser1.pos; handles.Laser2.pos], handles.numLasers);

end
% ----------------  plot_geo END-----------------%
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editNumLaser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobuttonPlotMuaC.
function radiobuttonPlotMuaC_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonPlotMuaC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonPlotMuaC


% --- Executes when selected object is changed in uipanelModeSelection.
function uipanelModeSelection_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanelModeSelection 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
selectedObj = get(handles.uipanelModeSelection, 'SelectedObject');
mode = get(selectedObj, 'String');
set(handles.textContDis1,'Visible','On');
set(handles.textContDis2,'Visible','On');
set(handles.textContNumLaser, 'Visible','On')   
set(handles.textContNoiseLevel, 'Visible','On');
set(handles.radiobuttonPlotFluence,'Enable','on');

set(handles.radiobuttonPlotMuaC,'Enable','off');
set(handles.radiobuttonPlotUltraSignal,'Enable','on');

        set(handles.editWavFrom, 'Enable','Off');
        set(handles.editWavTo, 'Enable','Off');
        set(handles.editWavStep, 'Enable','Off');
switch mode
    case 'Forward Simulation'
        set(handles.textContDis1,'Visible','Off');
        set(handles.textContDis2,'Visible','Off');
        set(handles.textContNumLaser, 'Visible','Off')
        set(handles.textContNoiseLevel, 'Visible','Off');
        
        set(handles.radiobuttonPlotUltraSignal,'Enable','on');

        set(handles.radiobuttonPlotMuaC,'Enable','on')
        
        set(handles.editWavFrom, 'Enable','On');
        set(handles.editWavTo, 'Enable','On');
        set(handles.editWavStep, 'Enable','On');
         
    case 'Manual Fitting'
        
      %%%%%%%%%%%%%%%%%%%%%%%  Continuous mode STARR %%%%%%%%%%%%%%%%%%%%%%%     
    % --------------  PARAMETERS ASSIGNMENT -------------------- % 
        % ----------------- get wavelengths START --------------%
    wav_min = str2double(get(handles.editWavFrom,'String'));
    wav_max = str2double(get(handles.editWavTo,'String'));
    wav_step = str2double(get(handles.editWavStep,'String'));
    handles.wavList = wav_min: wav_step: wav_max;
    % ----------------- get wavelengths END  ---------------%
    handles.cont.wavList = handles.wavList;
    handles.cont.StOv = get(handles.sliderStOv, 'Value');
    
    handles.cont.TCHb = get(handles.sliderTCHb, 'Value');
    handles.cont.StOb = get(handles.sliderStOb, 'Value');
    handles.cont.COHb = handles.cont.StOb * handles.cont.TCHb;
    handles.cont.CHHb = handles.cont.TCHb - handles.cont.COHb;
    
    handles.cont.CH2O = get(handles.sliderCH2O, 'Value');
    handles.cont.CLipid = get(handles.sliderCLipid, 'value');

    % following paras are the same with ref
    handles.cont.a = get(handles.slidera, 'Value');
    handles.cont.b = get(handles.sliderb, 'Value');

    handles.cont.vesselpos = handles.Vessel.pos;
    handles.cont.laserpos = [handles.Laser1.pos ; handles.Laser2.pos]; %(r,z) --> (x,y)
    handles.cont.numLasers = handles.numLasers;
    % --------------  PARAMETERS ASSIGNMENT END ---------------- % 
   
    
    % -----------------  Cont Forward Start ------------------- %
    handles.cont.ForwardResult = forwardFcn(handles.cont);

    % -----------------  Cont Forward End --------------------- %
    

    % --------------------- DISPLAY RESULT -----------------------%
        axes(handles.axesForwardResult)
        cla
        hold on
            ylabel('value')
    xlabel('data index')

        if  isfield(handles, 'ref')
            plot(handles.cont.ForwardResult,'-oc')
            plot(handles.ref.ForwardResult,'-ob')
            plot(handles.ref.rDataRefNoise,'-*r')
            legend('manual fitting', 'reference', 'noisy reference')
        else
            plot(handles.cont.ForwardResult,'-oc')
            %plot(handles.cont.ForwardResult+noise,'-*r')
     
            legend('manual fitting')
        end
        
  % ------------------  DISPLAY RESULT END ---------------------%
  
   % ----------------- plot fluence START ------------------%
   if get(handles.radiobuttonPlotFluence, 'Value') == 1
    handles.plotF = handles.cont;
    handles.plotF.wav = get(handles.sliderWav, 'Value');
    handles.plotF.IsSound = get(handles.radiobuttonIsSound,'Value');
%         axes(handles.axesFluence)
        handles.plotF.axesFluence = handles.axesFluence;
        handles.plotF.uiPanel = handles.uipanelFluence;
    plot_fluence(handles.plotF)
   end
    % ----------------- plot fluence END ------------------%
 %%%%%%%%%%%%%%%%%%%%%%%  Continuous mode END %%%%%%%%%%%%%%%%%%%%%%% 
   
    case 'Reconstruction'
        set(handles.radiobuttonPlotFluence,'Enable','off');
        set(handles.radiobuttonPlotUltraSignal,'Enable','off');
end
guidata(hObject, handles);

% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
selectedObj = get(handles.uipanel4, 'SelectedObject');
tissueType = get(selectedObj, 'String');

switch tissueType
%     case 'Head'
%     set(handles.editStOvRef, 'String', num2str(0.62))
%     set(handles.editTHbRef, 'String', num2str(0.078)) %  
%     set(handles.editStObRef, 'String', num2str(0.7))
%     set(handles.editCH2ORef, 'String', num2str(0.64))
%     set(handles.editaRef, 'String', num2str(0.6))
%     set(handles.editbRef, 'String', num2str(0.3)) % a and b vary a lot, but this is reasonable.
%     
    case 'Forearm'
    set(handles.editStOvRef, 'String', num2str(0.98)) % artery
    set(handles.editTHbRef, 'String', num2str(0.117)) %  Jacques_PMB2013
    set(handles.editStObRef, 'String', num2str(0.64))
    set(handles.editCH2ORef, 'String', num2str(0.2)) % have not found this value
    set(handles.editaRef, 'String', num2str(0.8))
    set(handles.editbRef, 'String', num2str(0.2)) % a and b vary a lot, but this is reasonable.
end
guidata(hObject, handles);

% --- Executes on button press in radiobuttonPlotUltraSignal.
function radiobuttonPlotUltraSignal_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonPlotUltraSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonPlotUltraSignal


% --- Executes on slider movement.

% --- Executes on button press in radiobuttonPlotFluence.
function radiobuttonPlotFluence_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonPlotFluence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonPlotFluence

function radiobuttonIsSound_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonPlotFluence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 isSound = get(handles.radiobuttonIsSound,'Value');
 if isSound  
     % generate sound
 end

% --- Creates and returns a handle to the GUI figure. 
function h1 = GUI_main_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end
%load GUI_main.mat



appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', [], ...
    'uipanel', 15, ...
    'radiobutton', 9, ...
    'axes', 17, ...
    'text', 64, ...
    'edit', 20, ...
    'slider', 14, ...
    'pushbutton', []), ...
    'override', [], ...
    'release', 13, ...
    'resize', 'simple', ...
    'accessibility', 'callback', ...
    'mfile', [], ...
    'callbacks', [], ...
    'singleton', [], ...
    'syscolorfig', [], ...
    'blocking', 0, ...
    'lastSavedFile', '/Users/jiangjingjing/Google Drive/usz_project/noise_analysis_optoacoustics/optoacoustic_program(created05.02.2016)/GUI_main.m', ...
    'lastFilename', '/Users/jiangjingjing/Google Drive/usz_project/noise_analysis_optoacoustics/tabbed_optoacoustics(created04.02.2015)/GUI.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

% --------------- cross-platform display ------------------- %
set(0,'units','pixels')  
%Obtains this pixel information
my_res = [1    1  1366    768];
my_ratio = 1366/768;
%Sets the units of your root object (screen) to pixels
set(0,'units','pixels')  
%Obtains this pixel information
Res = get(0,'screensize');
ratio = Res(3)/Res(4);
%Sets the units of your root object (screen) to inches
% set(0,'units','inches')
% %Obtains this inch information
% Inch_SS = get(0,'screensize');
% %Calculates the resolution (pixels per inch)
% Res = Pix_SS./Inch_SS;
 
if ratio <= my_ratio
     if Res(3) > my_res(3)
        r = Res(3)/my_res(3).*ones(1,4);
     else
        r = Res(4)/my_res(4) .*ones(1,4);  
     end
    
else
    if Res(4) > my_res(4)
        r = Res(4)/my_res(4) .*ones(1,4);
    else
        r = Res(3)/my_res(3) .*ones(1,4);
    end
end
 
% -----------------------end ----------------------------%


% -----------------------end ----------------------------%
h1 = figure(...
'Units','pixels',...
'Color',[0.929411764705882 0.929411764705882 0.929411764705882],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','VirtualOA: a virtual lab of optoacoustic imaging',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position', r.*  [33 59 1300 650],...
'Resize',get(0,'defaultfigureResize'),...
'HandleVisibility','callback',...
'UserData',[],...
'Tag','figure1',...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h1, 'Units', 'Normalized');
appdata = [];
appdata.lastValidTag = 'uipanelModeSelection';
set(h1, 'Units', 'Normalized');

h2 = uibuttongroup(...
'Parent',h1,...
'Units','pixels',...
'Title',{  'Modes' },...
'Clipping','on',...
'Position', r.*  [50 570 450 50],...
'Tag','uipanelModeSelection',...
'SelectedObject',[],...
'SelectionChangeFcn',@(hObject,eventdata)GUI_main('uipanelModeSelection_SelectionChangeFcn',get(hObject,'SelectedObject'),eventdata,guidata(get(hObject,'SelectedObject'))),...
'OldSelectedObject',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h2, 'Units', 'Normalized');
appdata = [];
appdata.lastValidTag = 'radiobuttonSingleForward';

h3 = uicontrol(...
'Parent',h2,...
'Units','pixels',...
'Position', r.*  [10 5 150 30],...
'String','Forward Simulation',...
'Style','radiobutton',...
'Tag','radiobuttonSingleForward',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'radiobuttonContForward';
set(h3, 'Units', 'Normalized');

h4 = uicontrol(...
'Parent',h2,...
'Units','pixels',...
'Position', r.*  [160 5 150 30],...
'String','Manual Fitting',...
'Style','radiobutton',...
'Tag','radiobuttonContForward',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'radiobuttonRec';
set(h4, 'Units', 'Normalized');

h5 = uicontrol(...
'Parent',h2,...
'Units','pixels',...
'Position', r.*  [330 5 100 30],...
'String','Reconstruction',...
'Style','radiobutton',...
'Tag','radiobuttonRec',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h5, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'uipanel4';

h6 = uibuttongroup(...
'Parent',h1,...
'Units','pixels',...
'Title',{  'Load example tissue properties' },...
'Clipping','on',...
'Position', r.*  [50 510 150 50],...
'Tag','uipanel4',...
'SelectedObject',[],...
'SelectionChangeFcn',@(hObject,eventdata)GUI_main('uipanel4_SelectionChangeFcn',get(hObject,'SelectedObject'),eventdata,guidata(get(hObject,'SelectedObject'))),...
'OldSelectedObject',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h6, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'uipanel5';

h7 = uibuttongroup(...
'Parent',h1,...
'Units','pixels',...
'Title',{  'Set wavelengths (within [650,910] nm)' },...
'Clipping','on',...
'Position', r.*  [220 510 280 50],...
'Tag','uipanel5',...
'SelectedObject',[],...
'SelectionChangeFcn',@(hObject,eventdata)GUI_main('uipanel5_SelectionChangeFcn',get(hObject,'SelectedObject'),eventdata,guidata(get(hObject,'SelectedObject'))),...
'OldSelectedObject',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h7, 'Units', 'Normalized');



appdata = [];
appdata.lastValidTag = 'textSetWavFrom';

h7_1 = uicontrol(...
'Parent',h7,...
'Units','pixels',...
'Position', r.*  [10 10  50 20],...
'String','From',...
'Style','text',...
'Tag','textSetWavFrom',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h7_1, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSetWavTo';

h7_1 = uicontrol(...
'Parent',h7,...
'Units','pixels',...
'Position', r.*  [75 10  50 20],...a
'String','to',...
'Style','text',...
'Tag','textSetWavTo',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h7_1, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSetWavStep';

h7_1 = uicontrol(...
'Parent',h7,...
'Units','pixels',...
'Position', r.*  [155 10  50 20],...
'String','at a step of',...
'Style','text',...
'Tag','textSetWavStep',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h7_1, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editWavFrom';

h7_2 = uicontrol(...
'Parent',h7,...
'Units','pixels',...
'Position', r.*  [53 10  34 20],...
'String','650',...
'Style','edit',...
'Tag','editWavFrom');
set(h7_2, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editWavTo';

h7_3 = uicontrol(...
'Parent',h7,...
'Units','pixels',...
'Position', r.*  [114 10  34 20],...
'String','910',...
'Style','edit',...
'Tag','editWavTo');
set(h7_3, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editWavStep';

h7_4 = uicontrol(...
'Parent',h7,...
'Units','pixels',...
'Position', r.*  [210 10  34 20],...
'String','10',...
'Style','edit',...
'Tag','editWavStep');
set(h7_4, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'radiobuttonForearm';

h8 = uicontrol(...
'Parent',h6,...
'Units','pixels',...
'Position', r.*  [10 5 150 30],...
'String','Forearm',...
'Style','radiobutton',...
'Tag','radiobuttonForearm',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h8, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'uipanelTabs';

h9 = uipanel(...
'Parent',h1,...
'Units','pixels',...
'BorderType','none',...
'UserData',[],...
'Clipping','on',...
'Position', r.*  [530 30 720 600],...
'Tag','uipanelTabs',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h9, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'P1';

h10 = uipanel(...
'Parent',h9,...
'Units','pixels',...
'BorderType','none',...
'Title',blanks(0),...
'Clipping','on',...
'Position', r.*  [0 0 720 600],...
'Tag','P1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h10, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesUltra';

h11 = axes(...
'Parent',h10,...
'Units','pixels',...
'Position', r.*  [50 50 100 200],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[16.4747690595437 4.80089790897909 12.0392543127435 3.27333948339483],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesUltra',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h11, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'text23';

h16 = uicontrol(...
'Parent',h10,...
'Units','pixels',...
'Position', r.*  [210  293 96 14],...
'String','Forward Result',...
'Style','text',...
'Tag','text23',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h16, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesForwardResult';

h17 = axes(...
'Parent',h10,...
'Units','pixels',...
'Position', r.*  [205  45 475 240],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[26.4821960068776 4.8925503635217 19.352374005026 3.33582979331025],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesForwardResult',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h17, 'Units', 'Normalized');


appdata = [];
appdata.lastValidTag = 'uipanelGeo';

h22 = uipanel(...
'Parent',h10,...
'Units','pixels',...
'Title','Simulation model',...%'Fluence for laser 1 at wavelength [nm]',...
'UserData',[],...
'Clipping','on',...
'Position', r.*  [10 330 270 260],...
'Tag','uipanel3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h22, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesModel';

h23 = axes(...
'Parent',h22,...
'Units','pixels',...
'Position', r.*  [40 35 200 200],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[26.3938767395626 4.97851102941177 19.2878330019881 3.3944393382353],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesModel',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h23, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'uipanelFluence';

h33 = uipanel(...
'Parent',h10,...
'Units','pixels',...
'Title','Fluence for laser 1 at wavelength [nm]',...
'UserData',[],...
'Clipping','on',...
'Position', r.*  [300 330 400 260],...
'Tag','uipanelFluence',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h33, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesFluence';

h28 = axes(...
'Parent',h33,...
'Units','pixels',...
'Position', r.*  [130  40 200 180],...%r.*  [35 35 225 185],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[15.7741071428571 3.07627118644068 11.5272321428571 2.09745762711865],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesFluence',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h28, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesFluenceEq';

h28_2 = axes(...
'Parent',h33,...
'Units','pixels',...
'Position', r.*  [20  228 100 18],...%r.*  [35 35 225 185],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[15.7741071428571 3.07627118644068 11.5272321428571 2.09745762711865],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesFluenceEq',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h28_2, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'radiobuttonIsSound';

h28_1 = uicontrol(...
'Parent',h33,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('radiobuttonIsSound_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [15 200 100 20],...
'String','generate sound',...
'Style','radiobutton',...
'Tag','radiobuttonIsSound',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h28_1, 'Units', 'Normalized');



 

appdata = [];
appdata.lastValidTag = 'sliderWav';

h34 = uicontrol(...
'Parent',h33,...
'Units','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)GUI_main('sliderWav_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Max',910,...
'Min',650,...
'Position', r.*  [45 40 15 145],...
'String',{  'Slider' },...
'Style','slider',...
'SliderStep',[1/(910-650) 5*1/(910-650)],...
'Value',700,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('sliderWav_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'UserData',[],...
'Tag','sliderWav');
set(h34, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textWav';

h35 = uicontrol(...
'Parent',h33,...
'Units','pixels',...
'CData',[],...
'Position', r.*  [5 105 30 15 ],...
'String','700',...
'Style','text',...
'UserData',[],...
'Tag','textWav',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h35, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textWavL';

h36 = uicontrol(...
'Parent',h33,...
'Units','pixels',...
'CData',[],...
'Position', r.*  [65 40 25 14 ],...
'String','650',...
'Style','text',...
'UserData',[],...
'Tag','textWavL',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h36, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textWavH';

h37 = uicontrol(...
'Parent',h33,...
'Units','pixels',...
'CData',[],...
'Position', r.*  [65 170 25 14 ],...
'String','910',...
'Style','text',...
'UserData',[],...
'Tag','textWavH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h37, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'text62';

h38 = uicontrol(...
'Parent',h10,...
'Units','pixels',...
'Position', r.*  [20 255 130 50],...
'String',{'Normalized degree';' of ultrasound signal';' for different distances [mm]'},...
'Style','text',...
'Tag','text62',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h38, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'P2';

h45 = uipanel(...
'Parent',h10,...
'Units','pixels',...
'BorderType','none',...
'Title',blanks(0),...
'Clipping','on',...
'Position', r.*  [0 0 720 600],...
'Tag','P2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h45, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'text25';

h46 = uicontrol(...
'Parent',h45,...
'Units','pixels',...
'Position', r.*  [350 500 200 30],...
'String',{'Reconstruction Result 2:';'All parameters        '},...
'Style','text',...
'Tag','text25',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h46, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'text24';

h47 = uicontrol(...
'Parent',h45,...
'Units','pixels',...
'CData',[],...
'Position', r.*  [30 500  250 30],...
'String',{'Reconstruction Resul 1:   '; 'StO for blood vessel and bulk'},...
'Style','text',...
'UserData',[],...
'Tag','text24',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h47, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesRecStOBulk';

h48 = axes(...
'Parent',h45,...
'Units','pixels',...
'Position', r.*  [190 50 60 420],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[22.0523607381096 5.25569804151169 16.115186693234 3.58343048284887],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesRecStOBulk',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h48, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesRecStO';

h53 = axes(...
'Parent',h45,...
'Units','pixels',...
'Position', r.*  [70 50 60 420],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[22.5250493726576 5.25531162153952 16.460613003096 3.58316701468603],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesRecStO',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h53, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesRecResult';

h58 = axes(...
'Parent',h45,...
'Units','pixels',...
'Position', r.*  [320 50  370 420],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[22.4538565527065 5.26140300546448 16.408587480824 3.58732023099851],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesRecResult',...
'UserData',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h58, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'uipanel2';

h63 = uipanel(...
'Parent',h1,...
'Units','pixels',...
'Title',{  'Parameters' },...
'Clipping','on',...
'Position', r.*  [50 30 450 470],...
'Tag','uipanel2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h63, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleStOv';

h64 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [22.5 400  112.5 32],...
'String','Oxygen Saturation for blood vessel StOv ',...
'Style','text',...
'Tag','textTitleStOv',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h64, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleRef';

h65 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [135 430  67.5 20],...
'String','Reference',...
'Style','text',...
'Tag','text2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h65, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleManualFitting';

h66 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [202.5 430  157.5 20],...
'String','Manual fitting',...
'Style','text',...
'Tag','textTitleManualFitting',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h66, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleInitial';

h67 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [360 430  67.5 20],...
'String','Initial guess',...
'Style','text',...
'Tag','textTitleInitial',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h67, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editStOvRef';

h68 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editStOvRef_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [148.75 408  40 20],...
'String','0.62',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editStOvRef_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editStOvRef');
set(h68, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'text5';

h69 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [22.5 366  112.5 30],...
'String','Total Hb concentration for bulk [mM]',...
'Style','text',...
'Tag','text5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h69, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editStOvInit';

h70 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editStOvInit_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [375 408  40 20],...
'String','0.6',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editStOvInit_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editStOvInit');
set(h70, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderStOvL';

h71 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [240 402  20 13],...
'String','0',...
'Style','text',...
'Tag','textSliderStOvL',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h71, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderStOvH';

h72 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [320 402  20 13],...
'String','1',...
'Style','text',...
'Value',[],...
'Tag','textSliderStOvH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h72, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editTHbRef';

h73 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editTHbRef_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [148.75 372 40 20],...
'String','0.05',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editTHbRef_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editTHbRef');
set(h73, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleStOb';

h74 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [22.5 330 112.5 30],...
'String','Oxygen saturation for bulk StOb',...
'Style','text',...
'Tag','textTitleStOb',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h74, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editStObRef';

h75 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editStObRef_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [148.75 336 40 20],...
'String','0.7',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editStObRef_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editStObRef');
set(h75, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleParaScattering';

h761 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [15.5 168.5 100.5 80],...
'String',{  'Reduced scattering parameter mus=';'a*(lambda/1000)^(-b) [mm-1]'; blanks(0) },...
'Style','text',...
'Tag','textTitlea',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h761, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitlea';

h76 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [122.5 231.5 10 15],...
'String',{  'a '; blanks(0) },...
'Style','text',...
'Tag','textTitlea',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h76, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editaRef';

h77 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editaRef_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [148.75 228 40 20],...
'String','0.3',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editaRef_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editaRef');
set(h77, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleb';

h78 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [122.5 195 10 15],...
'String',{  'b '; blanks(0) },...
'Style','text',...
'Tag','textTitleb',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h78, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editbRef';

h79 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editbRef_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [148.75 192 40 20],...
'String','0.6',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editbRef_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editbRef');
set(h79, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleNoise';

h80 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [22.5 150 112.5 30],...
'String','Noise level [0,10%]',...
'Style','text',...
'Tag','textTitleNoise',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h80, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editNoiseLevel';

h81 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editNoiseLevel_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [148.75 156 40 20],...
'String','0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editNoiseLevel_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editNoiseLevel');
set(h81, 'Units', 'Normalized');


appdata = [];
appdata.lastValidTag = 'textContNoiseLevel';

h811 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [148.75 156 40 20],...
'String','0',...
'Style','text',...
'Tag','textContNoiseLevel',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'Visible', 'Off');
set(h811, 'Units', 'Normalized');


appdata = [];
appdata.lastValidTag = 'pushbutton1';

h82 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('pushbutton1_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [175 20 100 30],...
'String','START',...
'Tag','pushbutton1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h82, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'sliderStOv';

h83 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)GUI_main('sliderStOv_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [242.5 413 100 15],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.7,...
'Max', 1,...
'Min', 0.3,...
'SliderStep', [0.01 / (1-0.3), 0.1/(1-0.3)],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('sliderStOv_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','sliderStOv');
set(h83, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textStOvCont';

h84 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [210 417  30 13],...
'String','0.7',...
'Style','text',...
'Tag','textStOvCont',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h84, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderTCHbL';

h85 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [240 365 30 13],...
'String','0',...
'Style','text',...
'Tag','textSliderTCHbL',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h85, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderTCHbH';

h86 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [320 365 30 13],...
'String','0.1',...
'Style','text',...
'Value',[],...
'Tag','textSliderTCHbH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h86, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'sliderTCHb';

h87 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)GUI_main('sliderTCHb_Callback',hObject,eventdata,guidata(hObject)),...
'Max',0.1,...
'Position', r.*  [242.5 377 100 15],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.08,...
'Max',0.15,...
'Min',0.03,...
'SliderStep',[0.001/(0.15-0.03) 0.01/(0.15-0.03)],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('sliderTCHb_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','sliderTCHb');
set(h87, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTCHbCont';

h88 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Max',0.01,...
'Position', r.*  [210 382 30 13],...
'String','0.05',...
'Style','text',...
'SliderStep',[0.1 0.1],...
'Value',0.002,...
'Tag','textTCHbCont',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h88, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderStObL';

h89 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [240 328 30 13],...
'String','0',...
'Style','text',...
'Tag','textSliderStObL',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h89, 'Units', 'Normalized');


appdata = [];
appdata.lastValidTag = 'textSliderStObH';

h90 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [320 328 30 13],...
'String','1',...
'Style','text',...
'Value',[],...
'Tag','textSliderStObH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h90, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'sliderStOb';

h91 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)GUI_main('sliderStOb_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [242.5 341 100 15],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.5,...
'Max',1,...
'Min', 0.3,...
'SliderStep',[0.01/(1-0.3) 0.1/(1-0.3)],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('sliderStOb_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','sliderStOb');
set(h91, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textStObCont';

h92 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [210 346  30 13],...
'String','0.96',...
'Style','text',...
'SliderStep',[0.1 0.1],...
'Value',0.002,...
'Tag','textStObCont',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h92, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editTCHbInit';

h93 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editTCHbInit_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [375 372 40 20],...
'String',' 0.06',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editTCHbInit_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editTCHbInit');
set(h93, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editStObInit';

h94 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editStObInit_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [375 336 40 20],...
'String','0.9',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editStObInit_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editStObInit');
set(h94, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editaInit';

h95 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editaInit_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [375 228 40 20],...
'String','1',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editaInit_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editaInit');
set(h95, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editbInit';

h96 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editbInit_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [375 192 40 20],...
'String','1',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editbInit_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editbInit');
set(h96, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSlideraL';

h97 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [240 220 30 13],...
'String','0',...
'Style','text',...
'Tag','textSlideraL',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h97, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSlideraH';

h98 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [320 220 30 13],...
'String','1.5',...
'Style','text',...
'Value',[],...
'Tag','textSlideraH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h98, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'slidera';

h99 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)GUI_main('slidera_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [242.5 233 100 15],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.7,...
'Min', 0.2,...
'Max',1.5,...
'SliderStep',[0.01/(1.5-0.2) 0.1/(1.5-0.2)],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('slidera_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','slidera');
set(h99, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textaCont';

h100 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [210 238  30 13],...
'String','0.3',...
'Style','text',...
'Value',0.002,...
'Tag','textaCont',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h100, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderbL';

h101 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [240 184 30 13],...
'String','0',...
'Style','text',...
'Tag','textSliderbL',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h101, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderbH';

h102 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [320  184 30 13],...
'String','1',...
'Style','text',...
'Value',[],...
'Tag','textSliderbH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h102, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'sliderb';

h103 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)GUI_main('sliderb_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [242.5 197 100 15],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.5,...
'Max', 1,...
'Min',0.05,...
'SliderStep',[0.01/(1-0.05) 0.1/(1-0.05)],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('sliderb_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','sliderb');
set(h103, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textbCont';

h104 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [210 202  30 13],...
'String','0.5',...
'Style','text',...
'SliderStep',[0.1 0.1],...
'Value',0.002,...
'Tag','textbCont',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h104, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleCH2O';

h105 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [22.5 294 112.5 30],...
'String','H2O volume fraction for bulk',...
'Style','text',...
'Tag','textTitleCH2O',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h105, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editCH2ORef';

h106 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editCH2ORef_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [148.75 300 40 20],...
'String','0.65',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editCH2ORef_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editCH2ORef');
set(h106, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderCH2OL';

h107 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [240 292 30 13],...
'String','0',...
'Style','text',...
'Tag','textSliderCH2OL',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h107, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderCH2OH';

h108 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [320  292 30 13],...
'String','1',...
'Style','text',...
'Value',[],...
'Tag','textSliderCH2OH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h108, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'sliderCH2O';

h109 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)GUI_main('sliderCH2O_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position', r.*  [242.5 305 100 15],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.7,...
'Max', 0.9,...
'Min', 0.05,...
'SliderStep',[0.01/(0.9-0.05) 0.1/(0.9-0.05)],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('sliderCH2O_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'UserData',[],...
'Tag','sliderCH2O');
set(h109, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textCH2OCont';

h110 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [210 310  30 13],...
'String','0.4',...
'Style','text',...
'SliderStep',[0.1 0.1],...
'Value',0.4,...
'Tag','textCH2OCont',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h110, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editCH2OInit';

h111 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editCH2OInit_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [375 300 40 20],...
'String','0.4',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editCH2OInit_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editCH2OInit');
set(h111, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textDis1';

h112 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [210 98 140 30],...
'String',{  'Distance 1 (laser 1 to vessel)'; '[0,60]' },...
'Style','text',...
'Tag','textDis1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h112, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textDis2';

h113 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [210 64 150 30],...
'String',{  'Distance 2 (laser 1 to laser 2)'; '[-45, 45]' },...
'Style','text',...
'Tag','textDis2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h113, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editDis1';

h114 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editDis1_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [372.5  103 40 20],...
'String','15',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editDis1_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editDis1');
set(h114, 'Units', 'Normalized');


appdata = [];
appdata.lastValidTag = 'textContDis1';

h1141 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [372.5  103 40 20],...
'String','20',...
'Style','text',...
'Tag','textContDis1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata},...
'Visible','off');
set(h1141, 'Units', 'Normalized');



appdata = [];
appdata.lastValidTag = 'editDis2';

h115 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editDis2_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [372.5 72 40 20],...
'String','30',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editDis2_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editDis2');
set(h115, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textContDis2';

h1151 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [372.5 72 40 20],...
'String','40',...
'Style','text',...
'Tag','textContDis2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata},...
'Visible','off');
set(h1151, 'Units', 'Normalized');


appdata = [];
appdata.lastValidTag = 'textNumLaser';

h116 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [215 128 118 27],...
'String','Number of laser positions (>= 1)',...
'Style','text',...
'Tag','textNumLaser',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h116, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editNumLaser';

h117 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editNumLaser_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [372.5 135 40 20],...
'String','2',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editNumLaser_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editNumLaser');
set(h117, 'Units', 'Normalized');


appdata = [];
appdata.lastValidTag = 'textContNumLaser';
h1161 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [372.5 135 40 20],...
'String','5',...
'Style','text',...
'Tag','textContNumLaser',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata},...
'Visible','off');
set(h1161, 'Units', 'Normalized');


appdata = [];
appdata.lastValidTag = 'radiobuttonPlotMuaC';

h118 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('radiobuttonPlotMuaC_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [22.5 100 150 20],...
'String','plot spectra of coefficients ',...
'Style','radiobutton',...
'Tag','radiobuttonPlotMuaC',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h118, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'radiobuttonPlotUltraSignal';

h119 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('radiobuttonPlotUltraSignal_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [22.5 60 130 20],...
'String','plot ultrasound signal',...
'Style','radiobutton',...
'Tag','radiobuttonPlotUltraSignal',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h119, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'radiobuttonPlotFluence';

h120 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('radiobuttonPlotFluence_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position', r.*  [22.5 80 130 20],...
'String','plot fluence',...
'Style','radiobutton',...
'UserData',[],...
'Tag','radiobuttonPlotFluence',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h120, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'P3';

h121 = uipanel(...
'Parent',h9,...
'Units','pixels',...
'BorderType','none',...
'Title',blanks(0),...
'Clipping','on',...
'Position', r.*  [0 0 720 600],...
'Tag','P3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h121, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesPlotMuC1';

h122_1 = axes(...
'Parent',h121,...
'Units','pixels',...
'Position', r.*  [80 430 600 140],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[3.25 1.375 2.375 0.9375],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesPlotMuC1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h122_1, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesPlotMuC2';

h122 = axes(...
'Parent',h121,...
'Units','pixels',...
'Position', r.*  [80 235 600 140],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[3.25 1.375 2.375 0.9375],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesPlotMuC2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h122, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'axesPlotMuC3';

h123 = axes(...
'Parent',h121,...
'Units','pixels',...
'Position', r.*  [80 40 600 140],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[3.25 1.375 2.375 0.9375],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axesPlotMuC3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h123, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textTitleCLipid';

h124 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [22.5 258 112.5 30],...
'String','Concentration of Lipid for bulk [mM]',...
'Style','text',...
'Tag','textTitleCLipid',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h124, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editCLipidRef';

h125 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editCLipidRef_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [148.75 264 40 20],...
'String','0.4',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editCH2ORef_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editCLipidRef');
set(h125, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'sliderCLipid';

h126 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)GUI_main('sliderCLipid_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position', r.*  [242.5 269 100 15],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.4,...
'Max',0.6,...
'Min', 0.1,...
'SliderStep',[0.01/(0.6-0.1) 0.1/(0.6-0.1)],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('sliderCLipid_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'UserData',[],...
'Tag','sliderCLipid');
set(h126, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textCLipidCont';

h127 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [210 274  30 13],...
'String','0.4',...
'Style','text',...
'SliderStep',[0.1 0.1],...
'Value',0.4,...
'Tag','textCLipidCont',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h127, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'editCLipidInit';

h128 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Callback',@(hObject,eventdata)GUI_main('editCLipidInit_Callback',hObject,eventdata,guidata(hObject)),...
'Position', r.*  [375 264 40 20],...
'String','0.4',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)GUI_main('editCLipidInit_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','editCLipidInit');
set(h128, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderCLipidL';

h129 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [240 256 30 13],...
'String','0',...
'Style','text',...
'Tag','textSliderCLipidL',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h129, 'Units', 'Normalized');

appdata = [];
appdata.lastValidTag = 'textSliderCLipidH';

h130 = uicontrol(...
'Parent',h63,...
'Units','pixels',...
'Position', r.*  [320 256 30 13],...
'String','1',...
'Style','text',...
'Value',[],...
'Tag','textSliderCLipidH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
set(h130, 'Units', 'Normalized');

hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % GUI_main
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % GUI_main(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % GUI_main('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % GUI_main(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || (isscalar(fig)&&isprop(fig,'GUIDEFigure'));
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    GUI_mained = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if GUI_mained
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~GUI_mained
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    % Call version of openfig that accepts 'auto' option"
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton, visible);  
    %workaround for CreateFcn not called to create ActiveX
    if feature('HGUsingMATLABClasses')
        peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
        for i=1:length(peers)
            if isappdata(peers(i),'Control')
                actxproxy(peers(i));
            end            
        end
    end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


