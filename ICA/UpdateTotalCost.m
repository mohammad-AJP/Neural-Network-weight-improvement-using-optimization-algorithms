function emp=UpdateTotalCost(emp)
    global ICASettings;
    zeta=ICASettings.zeta;
    
    nEmp=numel(emp);
    
    for k=1:nEmp
        if emp(k).nCol>0
            emp(k).TotalCost=emp(k).Imp.Cost+zeta*mean([emp(k).Col.Cost]);
        else
            emp(k).TotalCost=emp(k).Imp.Cost;
        end
    end
end