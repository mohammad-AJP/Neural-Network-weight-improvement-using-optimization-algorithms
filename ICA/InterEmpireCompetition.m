function emp=InterEmpireCompetition(emp)
    if numel(emp)==1
        return;
    end
    global ICASettings;
    alpha=ICASettings.alpha;
    TotalCost=[emp.TotalCost];
    
    [~, WeakestEmpIndex]=max(TotalCost);
    WeakestEmp=emp(WeakestEmpIndex);
    
    P=exp(-alpha*TotalCost/max(TotalCost));
    P(WeakestEmpIndex)=0;
    P=P/sum(P);
    if any(isnan(P))
        P(isnan(P))=0;
        if all(P==0)
            P(:)=1;
        end
        P=P/sum(P);
    end
        
    if WeakestEmp.nCol>0
        [~, WeakestColIndex]=max([WeakestEmp.Col.Cost]);
        WeakestCol=WeakestEmp.Col(WeakestColIndex);
        WinnerEmpIndex=RouletteWheelSelection(P);
        WinnerEmp=emp(WinnerEmpIndex);
        WinnerEmp.Col(end+1)=WeakestCol;
        WinnerEmp.nCol=WinnerEmp.nCol+1;
        emp(WinnerEmpIndex)=WinnerEmp;
        WeakestEmp.Col(WeakestColIndex)=[];
        WeakestEmp.nCol=WeakestEmp.nCol-1;
        emp(WeakestEmpIndex)=WeakestEmp;
    end
    
    if WeakestEmp.nCol==0
        
        WinnerEmpIndex2=RouletteWheelSelection(P);
        WinnerEmp2=emp(WinnerEmpIndex2);
        
        WinnerEmp2.Col(end+1)=WeakestEmp.Imp;
        WinnerEmp2.nCol=WinnerEmp2.nCol+1;
        emp(WinnerEmpIndex2)=WinnerEmp2;
        
        emp(WeakestEmpIndex)=[];
    end
    
end