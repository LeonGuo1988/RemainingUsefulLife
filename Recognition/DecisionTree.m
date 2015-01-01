function [Tree RulesMatrix]=DecisionTree(DataSet,AttributName)
%输入为训练集，为离散后的数字，如记录1：1 1 3 2 1；
%前面为属性列，最后一列为类标
if nargin<1
    error('请输入数据集');
else
    if isstr(DataSet)
        [DataSet AttributValue]=readdata2(DataSet);
    else
        AttributValue=[];
    end
end
if nargin<2
   AttributName=[];
end
      Attributs=[1:size(DataSet,2)-1];
      Tree=CreatTree(DataSet,Attributs);
      disp([char(13) 'The Decision Tree:']);
      showTree(Tree,0,0,1,AttributValue,AttributName);
      Rules=getRule(Tree);
      RulesMatrix=zeros(size(Rules,1),size(DataSet,2));
      for i=1:size(Rules,1)
          rule=cell2struct(Rules(i,1),{'str'});
          rule=str2num([rule.str([1:(find(rule.str=='C')-1)]) rule.str((find(rule.str=='C')+1):length(rule.str))]);
          for j=1:(length(rule)-1)/2
              RulesMatrix(i,rule((j-1)*2+1))=rule(j*2);
          end
          RulesMatrix(i,size(DataSet,2))=rule(length(rule));
      end
end
function Tree=CreatTree(DataSet,Attributs)  %决策树程序 输入为：数据集，属性名列表
     %disp(Attributs);
     [S ValRecords]=ComputEntropy(DataSet,0);
     if(S==0)  %当样例全为一类时退出，返回叶子节点类标
         for i=1:length(ValRecords)
             if(length(ValRecords(i).matrix)==size(DataSet,1))
                 break;
             end
         end
         Tree.Attribut=i;
         Tree.Child=[];
         return;
     end
     if(length(Attributs)==0) %当条件属性个数为0时返回占多数的类标
        mostlabelnum=0;
        mostlabel=0;
        for i=1:length(ValRecords)
             if(length(ValRecords(i).matrix)>mostlabelnum)
                 mostlabelnum=length(ValRecords(i).matrix);
                 mostlabel=i;
             end
         end
         Tree.Attribut=mostlabel;
         Tree.Child=[];
         return;
     end
     for i=1:length(Attributs)
         [Sa(i) ValRecord]=ComputEntropy(DataSet,i);
         Gains(i)=S-Sa(i);
         AtrributMatric(i).val=ValRecord;
     end
     [maxval maxindex]=max(Gains);
     Tree.Attribut=Attributs(maxindex);
     Attributs2=[Attributs(1:maxindex-1) Attributs(maxindex+1:length(Attributs))];
     for j=1:length(AtrributMatric(maxindex).val)
         DataSet2=[DataSet(AtrributMatric(maxindex).val(j).matrix',1:maxindex-1) DataSet(AtrributMatric(maxindex).val(j).matrix',maxindex+1:size(DataSet,2))];        
         if(size(DataSet2,1)==0)
              mostlabelnum=0;
              mostlabel=0;
              for i=1:length(ValRecords)
                  if(length(ValRecords(i).matrix)>mostlabelnum)
                       mostlabelnum=length(ValRecords(i).matrix);
                       mostlabel=i;
                  end
              end
              Tree.Child(j).root.Attribut=mostlabel;
              Tree.Child(j).root.Child=[];
         else
            Tree.Child(j).root=CreatTree(DataSet2,Attributs2);
         end
     end 
end
function [Entropy RecordVal]=ComputEntropy(DataSet,attribut) %计算信息熵
     if(attribut==0)
         clnum=0;
         for i=1:size(DataSet,1)
             if(DataSet(i,size(DataSet,2))>clnum)  %防止下标越界
                 classnum(DataSet(i,size(DataSet,2)))=0;
                 clnum=DataSet(i,size(DataSet,2));
                 RecordVal(DataSet(i,size(DataSet,2))).matrix=[];
             end
             classnum(DataSet(i,size(DataSet,2)))=classnum(DataSet(i,size(DataSet,2)))+1;
             RecordVal(DataSet(i,size(DataSet,2))).matrix=[RecordVal(DataSet(i,size(DataSet,2))).matrix i];
         end

         Entropy=0;
         for j=1:length(classnum)
             P=classnum(j)/size(DataSet,1);
             if(P~=0)
                 Entropy=Entropy+(-P)*log2(P);
             end
         end
     else
         valnum=0;
         for i=1:size(DataSet,1)
             if(DataSet(i,attribut)>valnum)  %防止参数下标越界
                clnum(DataSet(i,attribut))=0;
                valnum=DataSet(i,attribut);
                Valueexamnum(DataSet(i,attribut))=0;
                RecordVal(DataSet(i,attribut)).matrix=[]; %将编号保留下来，以方便后面按值分割数据集
             end
             if(DataSet(i,size(DataSet,2))>clnum(DataSet(i,attribut)))  %防止下标越界
                 Value(DataSet(i,attribut)).classnum(DataSet(i,size(DataSet,2)))=0;
                 clnum(DataSet(i,attribut))=DataSet(i,size(DataSet,2));
             end
             Value(DataSet(i,attribut)).classnum(DataSet(i,size(DataSet,2)))= Value(DataSet(i,attribut)).classnum(DataSet(i,size(DataSet,2)))+1;
             Valueexamnum(DataSet(i,attribut))= Valueexamnum(DataSet(i,attribut))+1;
             RecordVal(DataSet(i,attribut)).matrix=[RecordVal(DataSet(i,attribut)).matrix i];
         end
         Entropy=0;
         for j=1:valnum
             Entropys=0;
             for k=1:length(Value(j).classnum)
                P=Value(j).classnum(k)/Valueexamnum(j);
                if(P~=0)
                   Entropys=Entropys+(-P)*log2(P);
                end
             end
             Entropy=Entropy+(Valueexamnum(j)/size(DataSet,1))*Entropys;
         end
     end
end
function showTree(Tree,level,value,branch,AttributValue,AttributName)
    blank=[];
    for i=1:level-1
        if(branch(i)==1)
           blank=[blank '            |']; 
        else
           blank=[blank '             '];  
        end
    end
    blank=[blank '            '];  
    if(level==0)
       blank=[' (The Root):'];
    else
       if isempty(AttributValue)
           blank=[blank '|_____' int2str(value)  '______'];
       else
           blank=[blank '|_____' value '______'];
       end
    end
    if(length(Tree.Child)~=0) %非叶子节点
        if isempty(AttributName)
             disp([blank 'Attribut ' int2str(Tree.Attribut)]);
        else
             disp([blank 'Attribut ' AttributName{Tree.Attribut}]);
        end
        if isempty(AttributValue)
           for j=1:length(Tree.Child)-1
               showTree(Tree.Child(j).root,level+1,j,[branch 1],AttributValue,AttributName);
           end
           showTree(Tree.Child(length(Tree.Child)).root,level+1,length(Tree.Child),[branch(1:length(branch)-1) 0 1],AttributValue,AttributName);
        else
           for j=1:length(Tree.Child)-1
               showTree(Tree.Child(j).root,level+1,AttributValue{Tree.Attribut}{j},[branch 1],AttributValue,AttributName);
           end
           showTree(Tree.Child(length(Tree.Child)).root,level+1,AttributValue{Tree.Attribut}{length(Tree.Child)},[branch(1:length(branch)-1) 0 1],AttributValue,AttributName);
        end
    else
       if isempty(AttributValue)
           disp([blank 'leaf ' int2str(Tree.Attribut)]);
       else
           disp([blank 'leaf ' AttributValue{length(AttributValue)}{Tree.Attribut}]);
       end
    end     
end
function Rules=getRule(Tree)
            if(length(Tree.Child)~=0)
                  Rules={};
                  for i=1:length(Tree.Child)
                      content=getRule(Tree.Child(i).root);
                      %disp(content);
                      %disp([num2str(Tree.Attribut) ',' num2str(i) ',']);
                      for j=1:size(content,1)
                          rule=cell2struct(content(j,1),{'str'});
                          content(j,1)={[num2str(Tree.Attribut) ',' num2str(i) ',' rule.str]};
                      end
                      Rules=[Rules;content];
                  end
            else
               Rules={['C' num2str(Tree.Attribut)]};
          end     
end