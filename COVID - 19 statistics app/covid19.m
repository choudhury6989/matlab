classdef covid19 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        UIAxes                     matlab.ui.control.UIAxes
        AveragedofdaysSliderLabel  matlab.ui.control.Label
        AveragedofdaysSlider       matlab.ui.control.Slider
        OptionButtonGroup          matlab.ui.container.ButtonGroup
        CumulativeButton           matlab.ui.control.RadioButton
        DailyButton                matlab.ui.control.RadioButton
        DatatoPlotButtonGroup      matlab.ui.container.ButtonGroup
        CasesButton                matlab.ui.control.RadioButton
        DeathsButton               matlab.ui.control.RadioButton
        BothButton                 matlab.ui.control.RadioButton
        CountryLabel               matlab.ui.control.Label
        CountryListBox             matlab.ui.control.ListBox
        StateorReligionLabel       matlab.ui.control.Label
        StateorReligionListBox     matlab.ui.control.ListBox
    end

    
   properties (Access = public)
            
        indx_Count=1;            
        indx_State=0;            
        index=1;                 
        country='Global';        
        state='';
        DateT=[];
        indx_DtP='Cases';
        indx_Op='Cumulative';
        value_days=1 ;
       
    end
 

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
          load covid_data.mat covid_data;
            fprintf("plot %s \n", app.country);
            fprintf("plot %d \n", app.indx_Count);
            fprintf("plot %s \n", app.state);
            fprintf("plot %d \n", app.indx_State);
            if app.indx_State > app.indx_Count
                app.index=app.indx_State;
                fprintf("index %d \n", app.index);
            else
                app.index=app.indx_Count;
                fprintf("index %d \n", app.index);                
            end
            
          
           [r,c]=size(covid_data);
            i=app.index;
            exc=[11:18 43:56 61:93 105 106 122:131 192:195 251:260 262:317];
            C=[];
            Cc=[];
            Dd=[];
            D=[];
            dC=[];
            dD=[];
            v=0;
            vv=0;
            time=datetime(2020,1,22)+caldays(0:190);
                  for j=3:c
                    C=[C covid_data{i,j}(1,1)];
                    D=[D covid_data{i,j}(1,2)];
                  end 
                  
                  for j=3:c
                      for k=2:r
                          if k ~= exc
                       v=v+covid_data{k,j}(1,1);
                       vv=vv+covid_data{k,j}(1,2);
                          end
                      end
                      Cc(j-2)=[v];
                      Dd(j-2)=[vv];
                  end

                  
                  
                  
                  
                  
                  
            
            if i ~= 1
                 if isequal(app.indx_Op,'Cumulative') 
                   if isequal(app.indx_DtP,'Cases')
                       cla(app.UIAxes);
                      yyaxis(app.UIAxes,"left");
                      fprintf("cumulativecases \n");
                      bar(app.UIAxes,time,C);
                   elseif isequal(app.indx_DtP,'Deaths')
                       cla(app.UIAxes);
                      yyaxis(app.UIAxes,"right");
                      fprintf("cumulativedeath \n");
                      plot(app.UIAxes,time,D,"Color",'r');
                   elseif isequal(app.indx_DtP,'Both')
                       cla(app.UIAxes);
                      fprintf("cumulativeboth \n");
                      yyaxis(app.UIAxes,"left");
                       bar(app.UIAxes,time,C);
                      yyaxis(app.UIAxes,"right");
                       plot(app.UIAxes,time,D,"Color",'r');
                   end
                 elseif isequal(app.indx_Op,'Daily')
                     if app.value_days == 1
                        for i = 1:length(C)
                            if i == 1
                                dC(1)=[C(1)];
                                dD(1)=[D(1)];
                            else
                                dC=[dC C(i)-C(i-1)];
                                dD=[dD D(i)-D(i-1)];
                            end
                        end
                          if isequal(app.indx_DtP,'Both')
                             fprintf("DailyBoth \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"left");
                             bar(app.UIAxes,time,dC);
                             yyaxis(app.UIAxes,"right");
                             plot(app.UIAxes,time,dD,"Color",'r');
                         elseif isequal(app.indx_DtP,'Cases')
                             fprintf("DailyCases \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"left");
                             bar(app.UIAxes,time,dC);
                         elseif isequal(app.indx_DtP,'Deaths')
                             fprintf("DailyDeaths \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"right");
                             plot(app.UIAxes,time,dD,"Color",'r');
                          end
                     elseif app.value_days > 1 
                         for i=1:length(C)
                             if i == 1
                                dC(1)=[C(1)];
                                dD(1)=[D(1)];
                            else
                                dC=[dC C(i)-C(i-1)];
                                dD=[dD D(i)-D(i-1)];
                            end
                         end 
                         dMC = movmean(dC,[app.value_days-1,0]);
                         dMD = movmean(dD,[app.value_days-1,0]);
                         if isequal(app.indx_DtP,'Both')
                             fprintf("DailyBoth \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"left");
                             bar(app.UIAxes,time,dMC);
                             yyaxis(app.UIAxes,"right");
                             plot(app.UIAxes,time,dMD,"Color",'r');
                         elseif isequal(app.indx_DtP,'Cases')
                             fprintf("DailyCases \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"left");
                             bar(app.UIAxes,time,dMC);
                         elseif isequal(app.indx_DtP,'Deaths')
                             fprintf("DailyDeaths \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"right");
                             plot(app.UIAxes,time,dMD,"Color",'r');
                         end
                     end 
                 end
                 
                 
                 
                 
                 
            elseif i == 1
                fprintf("Global \n");
                 if isequal(app.indx_Op,'Cumulative')
                     
                     
                     
                     
                     
                   if isequal(app.indx_DtP,'Cases')
                       cla(app.UIAxes);
                      yyaxis(app.UIAxes,"left");
                      fprintf("cumulativecases \n");
                      bar(app.UIAxes,time,Cc);
                   elseif isequal(app.indx_DtP,'Deaths')
                       cla(app.UIAxes);
                      yyaxis(app.UIAxes,"right");
                      fprintf("cumulativedeath \n");
                      plot(app.UIAxes,time,Dd,"Color",'r');
                   elseif isequal(app.indx_DtP,'Both')
                       cla(app.UIAxes);
                      fprintf("cumulativeboth \n");
                      yyaxis(app.UIAxes,"left");
                       bar(app.UIAxes,time,Cc);
                      yyaxis(app.UIAxes,"right");
                      plot(app.UIAxes,time,Dd,"Color",'r');
                   end 
                 elseif isequal(app.indx_Op,'Daily')
                     if app.value_days == 1
                        for i = 1:length(Cc)
                            if i == 1
                                dC(1)=[Cc(1)];
                                dD(1)=[Dd(1)];
                            else
                                dC=[dC Cc(i)-Cc(i-1)];
                                dD=[dD Dd(i)-Dd(i-1)];
                            end
                        end
                          if isequal(app.indx_DtP,'Both')
                             fprintf("DailyBoth \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"left");
                             bar(app.UIAxes,time,dC);
                             yyaxis(app.UIAxes,"right");
                             plot(app.UIAxes,time,dD,"Color",'r');
                         elseif isequal(app.indx_DtP,'Cases')
                             fprintf("DailyCases \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"left");
                             bar(app.UIAxes,time,dC);
                         elseif isequal(app.indx_DtP,'Deaths')
                             fprintf("DailyDeaths \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"right");
                             plot(app.UIAxes,time,dD,"Color",'r');
                          end
                     elseif app.value_days > 1
                         date=app.value_days;
                         for i=1:length(Cc)
                             if i == 1
                                dC(1)=[Cc(1)];
                                dD(1)=[Dd(1)];
                            else
                                dC=[dC Cc(i)-Cc(i-1)];
                                dD=[dD Dd(i)-Dd(i-1)];
                            end
                         end 
                        dMC = movmean(dC,[date-1,0]);
                        dMD = movmean(dD,[date-1,0]);
                         if isequal(app.indx_DtP,'Both')
                             fprintf("DailyBoth \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"left");
                             bar(app.UIAxes,time,dMC);
                             yyaxis(app.UIAxes,"right");
                             plot(app.UIAxes,time,dMD,"Color",'r');
                         elseif isequal(app.indx_DtP,'Cases')
                             fprintf("DailyCases \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"left");
                             bar(app.UIAxes,time,dMC);
                         elseif isequal(app.indx_DtP,'Deaths')
                             fprintf("DailyDeaths \n");
                             cla(app.UIAxes);
                             yyaxis(app.UIAxes,"right");
                             plot(app.UIAxes,time,dMD,"Color",'r');
                         end
                     end
                 end
            end 
        end

        % Value changed function: CountryListBox
        function CountryListBoxValueChanged(app, event)
             load covid_data.mat covid_data;
             v = covid_data(:,1);
             c = app.CountryListBox.Value;
             app.country=c;
             app.startupFcn
             fprintf("Country name %s \n",c); 
             if strcmp(c,'Global')
                 app.indx_Count=1;
                 app.startupFcn
             end
             if strcmp('Australia',c)
                app.StateorReligionListBox.Items={['Australian Capital ' ...
                    'Territory'];'New South Wales';'Northern Territory';
                    'Queensland';'South Australia';'Tasmania';'Victoria';
                    'Western Australia'};                  
             end
             if strcmp('Canada',c)
                 app.StateorReligionListBox.Items={'Alberta';['British ' ...
                     'Columbia'];'Diamond Princess';'Grand Princess';
                     'Manitoba';'New Brunswick';'Newfoundland and Labrador';
                     'Northwest Territories';'Nova Scotia';'Ontario';
                     'Prince Edward Island';'Quebec';'Saskatchewan';
                     'Yukon'};
             end
             if strcmp('China',c)
                 app.StateorReligionListBox.Items={'Anhui';'Beijing';
                     'Chongqing';'Fujian';'Gansu';'Guangdong';'Guangxi';
                     'Guizhou';'Hainan';'Hebei';'Heilongjiang';'Henan';
                     'Hong Kong';'Hubei';'Hunan';'Inner Mongolia';
                     'Jiangsu';'Jiangxi';'Jilin';'Liaoning';'Macau';
                     'Ningxia';'Qinghai';'Shaanxi';'Shandong';'Shanghai';
                     'Shanxi';'Sichuan';'Tianjin';'Tibet';'Xinjiang';
                     'Yunnan';'Zhejiang'}; 
             end
             if strcmp('Denmark',c)
                 app.StateorReligionListBox.Items={'Faroe Islands';
                     'Greenland'};
             end
             if strcmp('France',c)
                 app.StateorReligionListBox.Items={'French Guiana';
                     'French Polynesia';'Guadeloupe';'Martinique';
                     'Mayotte';'New Caledonia';'Reunion';['Saint ' ...
                     'Barthelemy'];'Saint Pierre and Miquelon';
                     'St Martin'}; 
             end
             if strcmp('Netherland',c)
                 app.StateorReligionListBox.Items={'Aruba';['Bonaire, Sint' ...
                     ' Eustatius and Saba'];'Curacao';'Sint Maarten'}; 
             end
             if strcmp('United Kingdom',c)
                 app.StateorReligionListBox.Items={'Anguilla';'Bermuda';
                     'British Virgin Islands';'Cayman Islands';
                     'Channel Islands';'Falkland Islands (Malvinas)';
                     'Gibraltar';'Isle of Man';'Montserrat';['Turks ' ...
                     'and Caicos Islands']};  
             end
             if strcmp('United States',c)  
                 app.StateorReligionListBox.Items={'Alabama';'Alaska';
                     'American Samoa';'Arizona';'Arkansas';'California';
                     'Colorado';'Connecticut';'Delaware';['District of ' ...
                     'Columbia'];'Florida';'Georgia';'Guam';'Hawaii';'Idaho';
                     'Illinois';'Indiana';'Iowa';'Kansas';'Kentucky';
                     'Louisiana';'Maine';'Maryland';'Massachusetts';
                     'Michigan';'Minnesota';'Mississippi';'Missouri';
                     'Montana';'Nebraska';'Nevada';'New Hampshire';
                     'New Jersey';'New Mexico';'New York';'North Carolina';
                     'North Dakota';'Northern Mariana Islands';'Ohio';
                     'Oklahoma';'Oregon';'Pennsylvania';'Puerto Rico';
                     'Rhode Island';'South Carolina';'South Dakota';
                     'Tennessee';'Texas';'Utah';'Vermont';'Virgin Islands';
                     'Virginia';'Washington';'West Virginia';'Wisconsin';
                     'Wyoming'};
             end
             if ~strcmp('United States',c) && ~strcmp('United Kingdom',c) && ~strcmp('Netherland',c) && ~strcmp('France',c) && ~strcmp('Denmark',c) && ~strcmp('China',c) && ~strcmp('Canada',c) && ~strcmp('Australia',c)  
                 app.StateorReligionListBox.Items={'ALL'};
             end
             for i = 1 : length(v)
                 if strcmp(c,v(i))
                     fprintf("Country index %d \n",i);
                      title(app.UIAxes,"covid19 cases in " + app.country);
                      app.indx_Count=i;
                      app.startupFcn
                     return;
                 end
             end
        end

        % Selection changed function: DatatoPlotButtonGroup
        function DatatoPlotButtonGroupSelectionChanged(app, event)
            selectedButton = app.DatatoPlotButtonGroup.SelectedObject;
            app.indx_DtP=selectedButton.Text;
            app.startupFcn
           if app.CasesButton.Value
              fprintf("cases selected \n");
          end
          if app.DeathsButton.Value
              fprintf("death selected \n");    
          end
          if app.BothButton.Value
              fprintf("both selected \n");    
          end          
        end

        % Value changed function: StateorReligionListBox
        function StateorReligionListBoxValueChanged(app, event)
            load covid_data.mat covid_data; 
            s = app.StateorReligionListBox.Value;
            app.state=s;
            app.startupFcn
            fprintf("State name %s \n",s); 
            w=covid_data(:,2); 
            for i = 1 : length(w)
                if strcmp(s,w(i))
                   fprintf("State index %d \n",i);
                   title(app.UIAxes,"covid19 cases in " + s);
                   app.indx_State=i;
                   app.startupFcn
                end
            end
        end

        % Selection changed function: OptionButtonGroup
        function OptionButtonGroupSelectionChanged(app, event)
            selectedButton = app.OptionButtonGroup.SelectedObject;
            app.indx_Op=selectedButton.Text;
            app.startupFcn
            if app.CumulativeButton.Value
                fprintf("cumulative selected \n");
            end
            if app.DailyButton.Value
                fprintf("daily selected \n");
            end
        end

        % Value changed function: AveragedofdaysSlider
        function AveragedofdaysSliderValueChanged(app, event)
            value = app.AveragedofdaysSlider.Value;
            value = fix(value);
            fprintf("%d \n", value);
            app.value_days=value;
            app.startupFcn
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.0745 0.6235 1];
            app.UIFigure.Position = [100 100 683 557];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Daily Number of Cases and Deaths Title')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.Position = [10 217 659 341];

            % Create AveragedofdaysSliderLabel
            app.AveragedofdaysSliderLabel = uilabel(app.UIFigure);
            app.AveragedofdaysSliderLabel.HorizontalAlignment = 'right';
            app.AveragedofdaysSliderLabel.Position = [416 172 58 28];
            app.AveragedofdaysSliderLabel.Text = {'Averaged'; ' # of days'};

            % Create AveragedofdaysSlider
            app.AveragedofdaysSlider = uislider(app.UIFigure);
            app.AveragedofdaysSlider.Limits = [1 15];
            app.AveragedofdaysSlider.MajorTicks = [1 3 5 7 9 11 13 15];
            app.AveragedofdaysSlider.ValueChangedFcn = createCallbackFcn(app, @AveragedofdaysSliderValueChanged, true);
            app.AveragedofdaysSlider.MinorTicks = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
            app.AveragedofdaysSlider.Position = [495 187 153 3];
            app.AveragedofdaysSlider.Value = 1;

            % Create OptionButtonGroup
            app.OptionButtonGroup = uibuttongroup(app.UIFigure);
            app.OptionButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @OptionButtonGroupSelectionChanged, true);
            app.OptionButtonGroup.Title = 'Option';
            app.OptionButtonGroup.Position = [555 22 104 115];

            % Create CumulativeButton
            app.CumulativeButton = uiradiobutton(app.OptionButtonGroup);
            app.CumulativeButton.Text = 'Cumulative';
            app.CumulativeButton.Position = [11 69 82 22];
            app.CumulativeButton.Value = true;

            % Create DailyButton
            app.DailyButton = uiradiobutton(app.OptionButtonGroup);
            app.DailyButton.Text = 'Daily';
            app.DailyButton.Position = [11 48 65 22];

            % Create DatatoPlotButtonGroup
            app.DatatoPlotButtonGroup = uibuttongroup(app.UIFigure);
            app.DatatoPlotButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @DatatoPlotButtonGroupSelectionChanged, true);
            app.DatatoPlotButtonGroup.Title = 'Data to Plot';
            app.DatatoPlotButtonGroup.Position = [433 22 102 115];

            % Create CasesButton
            app.CasesButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.CasesButton.Text = 'Cases';
            app.CasesButton.Position = [11 69 58 22];
            app.CasesButton.Value = true;

            % Create DeathsButton
            app.DeathsButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.DeathsButton.Text = 'Deaths';
            app.DeathsButton.Position = [11 47 65 22];

            % Create BothButton
            app.BothButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.BothButton.Text = 'Both';
            app.BothButton.Position = [11 25 65 22];

            % Create CountryLabel
            app.CountryLabel = uilabel(app.UIFigure);
            app.CountryLabel.HorizontalAlignment = 'right';
            app.CountryLabel.Position = [30 164 51 22];
            app.CountryLabel.Text = 'Country:';

            % Create CountryListBox
            app.CountryListBox = uilistbox(app.UIFigure);
            app.CountryListBox.Items = {'Global', 'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burma', 'Burundi', 'Cabo Verde', 'Cambodia', 'Cameroon', 'Canada', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo (Brazzaville)', 'Congo (Kinshasa)', 'Costa Rica', 'Cote d''Ivoire', 'Croatia', 'Cuba', 'Cyprus', 'Czechia', 'Denmark', 'Diamond Princess', 'Djibouti', 'Dominica', 'Dominican Republic', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini', 'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Holy See', 'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Korea, South', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'MS Zaandam', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Mauritania', 'Mauritius', 'Mexico', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Namibia', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Macedonia', 'Norway', 'Oman', 'Pakistan', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland', 'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Somalia', 'South Africa', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Taiwan*', 'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States', 'Uruguay', 'Uzbekistan', 'Venezuela', 'Vietnam', 'West Bank and Gaza', 'Western Sahara', 'Yemen', 'Zambia', 'Zimbabwe', ''};
            app.CountryListBox.ValueChangedFcn = createCallbackFcn(app, @CountryListBoxValueChanged, true);
            app.CountryListBox.Position = [96 22 100 166];
            app.CountryListBox.Value = {};

            % Create StateorReligionLabel
            app.StateorReligionLabel = uilabel(app.UIFigure);
            app.StateorReligionLabel.HorizontalAlignment = 'right';
            app.StateorReligionLabel.Position = [223 154 56 28];
            app.StateorReligionLabel.Text = {'State or'; ' Religion:'};

            % Create StateorReligionListBox
            app.StateorReligionListBox = uilistbox(app.UIFigure);
            app.StateorReligionListBox.Items = {};
            app.StateorReligionListBox.ValueChangedFcn = createCallbackFcn(app, @StateorReligionListBoxValueChanged, true);
            app.StateorReligionListBox.Position = [294 20 100 164];
            app.StateorReligionListBox.Value = {};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = covid

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end