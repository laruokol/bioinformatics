# true.diversity
#
# Finds species diversity for samples in a sites-by-species
# data table X, according to Hill's numbers (see e.g., 
# Jost 2006, Oikos:113). The parameter 'q' affects how much 
# weight is put on species abundances.
#
# Special cases: 
#		when q = 0, the result is species richness (i.e., 
#                   zero wigth on abundance)
#		when q = 1, one gets Shannon's diversity (default), 
#                   or more specifically, exp(H), where 
#		            H = Shannon's entropy; here the weight
#                   is exactly equal to proportional abun-
#                   dance
#		when q = 2, inverse Simpson diversity is recovered.
#
# (c) Lasse Ruokolainen 2015
#        last modified: 1.8.2018
########################################################### 	


true.diversity = function(X,q = 1){
	if(class(X) == 'phyloseq'){
		X = t(otu_table(X))
	}
	
	if(!is.matrix(X)){
		X = as.matrix(X)
	}
		
        # Convert to proportional abundance:
	p = t(apply(X,1,function(x) x/sum(x)))	
	
	# Calculate diversity:
	if(q==0){
		# Special case of richness:
		D = rowSums(p>0, na.rm = TRUE) 
	}else{
		if(q==1){
			# Special case of Shannon-diversity: 
			D = -rowSums(p*log(p),na.rm=T)
		}else{
			D = rowSums(p^q,na.rm=T) ^ (1/(1-q))
		}
	}	
	return(D)
}
