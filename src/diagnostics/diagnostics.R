# diagnostics for a single site  --------------------------------------------
population_diagnostic<- function(dt){
  
  p<-   ggplot(data= dt, mapping = aes(x= year, y= cohort_size, color= scenario, fill= scenario))+
    geom_point(alpha= 0.5)  +
    facet_wrap_paginate(~age) +
    labs(x= 'Time (in years)', y= 'Population', title= paste0('Population over time: site ', unique(dt$site_name)),
         color= 'Scenario', fill= 'Scenario') +
    theme_minimal()+
    theme(text= element_text(family= 'Arial Narrow')) +
    scale_color_manual(values= wes_palette('Royal2', n= 2)) +
    scale_fill_manual(values= wes_palette('Royal2', n= 2)) 
  
  return(p)
  
}

incident_cases_diagnostic<- function(dt){
  
  p<-   ggplot(data= dt, mapping = aes(x= year, y= cases, color= scenario, fill= scenario))+
    geom_point(alpha= 0.5)  +
    facet_wrap_paginate(~age, scales= 'free') +
    labs(x= 'Time (in years)', y= 'Clinical cases', title= paste0('Incident clinical cases over time: site ', unique(dt$site_name)),
         color= 'Scenario', fill= 'Scenario') +
    theme_minimal()+
    theme(text= element_text(family= 'Arial Narrow')) +
    scale_color_manual(values= wes_palette('Royal2', n= 2)) +
    scale_fill_manual(values= wes_palette('Royal2', n= 2)) 
  
  return(p)
  
}

incidence_rate_diagnostic<- function(dt){
  
  p<-  ggplot(data= dt, mapping = aes(x= year, y= clinical, color= scenario, fill= scenario))+
    geom_point(alpha= 0.5)  +
    facet_wrap_paginate(~age, 
                        scales = 'free') +
    labs(x= 'Time (in years)', y= 'Incidence rate', title= paste0('Incidence rate over time: ', unique(dt$site_name)),
         color= 'Scenario', fill= 'Scenario') +
    theme_minimal()+
    theme(text= element_text(family= 'Arial')) +
    scale_color_manual(values= wes_palette('Royal2', n= 2)) +
    scale_fill_manual(values= wes_palette('Royal2', n= 2)) 
  
  return(p)
}



mortality_diagnostic<- function(dt){
  
  p<- ggplot(data= dt, mapping = aes(x= year, y= deaths, color= scenario, fill= scenario))+
    geom_point(alpha= 0.5)  +
    facet_wrap_paginate(~age, 
                        scales = 'free') +
    labs(x= 'Time (in years)', y= 'Deaths', title= paste0('Deaths over time: ', unique(output$site_name)),
         color= 'Scenario', fill= 'Scenario') +
    theme_minimal()+
    theme(text= element_text(family= 'Arial')) +
    scale_color_manual(values= wes_palette('Royal2', n= 2)) +
    scale_fill_manual(values= wes_palette('Royal2', n= 2)) 
  
  return(p)
  
}
mortality_rate_diagnostic<- function(dt){
  
  p<- ggplot(data= dt, mapping = aes(x= year, y= mortality, color= scenario, fill= scenario))+
    geom_point(alpha= 0.5)  +
    facet_wrap_paginate(~age, 
                        scales = 'free') +
    labs(x= 'Time (in years)', y= 'Mortality rate', title= paste0('Mortality rate over time: ', unique(output$site_name)),
         color= 'Scenario', fill= 'Scenario') +
    theme_minimal()+
    theme(text= element_text(family= 'Arial')) +
    scale_color_manual(values= wes_palette('Royal2', n= 2)) +
    scale_fill_manual(values= wes_palette('Royal2', n= 2)) 
  
  return(p)
  
}


daly_diagnostic<- function(dt){
  
  p<- ggplot(data= dt, mapping = aes(x= year, y= dalys, color= scenario, fill= scenario))+
    geom_point(alpha= 0.5)  +
    facet_wrap(~age, 
               scales = 'free') +
    labs(x= 'Time (in years)', y= 'DALYs', title= paste0('DALYs over time: ', unique(dt$site_name)),
         color= 'Scenario', fill= 'Scenario') +
    theme_minimal()+
    theme(text= element_text(family= 'Arial')) +
    scale_color_manual(values= wes_palette('Royal2', n= 2)) +
    scale_fill_manual(values= wes_palette('Royal2', n= 2)) 
  
  return(p)
}

