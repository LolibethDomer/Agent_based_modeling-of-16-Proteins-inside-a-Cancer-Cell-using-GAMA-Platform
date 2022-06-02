	/**
* Name: Proteins_Interaction_inside_Cancer_Cell
* Author: Lolibeth Domer 
*/
//

model Proteins_Interaction_inside_Cancer_Cell

global {
//Constant variables
	geometry shape <- envelope(square(1000));
	float size <-5.4 #m;//nm
	float distance <- 5.4*3 #m;// #nm;
	float time <- 1 #minute/1 #cycle; 
	float velocity_proteins<-10^4 #m/#minute const: true;
	float step<-1 #minute;
		
	int nn<-100; //initial no.
	int num_P53<- nn;
	int num_MIR145<- nn;
	int num_MIR200<- nn; 
	int num_MDM2<- nn; 
	int num_OCT4<- nn; 
	int num_ZEB<- nn; 
	
	int num_SNAIL<- nn;	
	int num_MIR34<-nn;
	
	int num_AMPK<-nn;
	int num_HIF1<-nn;
	int num_MTROS<-nn;
	int num_NOXROS<-nn;
	
	int num_RKIP<-nn;
	int num_LET7<-nn;
	int num_BACH1<-nn;
	int num_LIN28<-nn;
	
	//life span of Proteins
	float time_MDM2<-25.0 #cycle;
	float time_MIR200<-7200.0 #cycle;
	float time_MIR145<-7200.0 #cycle;
	float time_OCT4 <-440.4 #cycle;
	float time_P53_min<-5.0 #cycle;
	float time_P53_max<-20.0 #cycle;
	float time_P53_activated<-1440.0 #cycle;
	float time_ZEB_min <-2640.0 #cycle;
	float time_ZEB_max <-4080.0 #cycle;		
	  
	float time_SNAIL<-25.0 #cycle;
	float time_MIR34<-7200.0 #cycle; 
	
	float time_AMPK_min<- 120.0 #cycle;
	float time_AMPK_max<-240.0 #cycle;
	float time_HIF1_min<- 5.0 #cycle;
	float time_HIF1_max<- 8.0 #cycle;
	float time_MTROS<- 1.0 #cycle;
	float time_NOXROS<- 1.0 #cycle;
	
	float time_BACH1<- 1140.0 #cycle;
	float time_LET7<- 7200.0 #cycle;
	float time_LIN28<- 720.0 #cycle;
	float time_RKIP<- 30.0 #cycle;
	
	init {
		do create;
	}//init
	
	action clean{
		ask P53 {
			do die;}
		
		ask MIR145 {
			do die;}
			
		ask MIR200 {
			do die;}
		
		ask MDM2 {
			do die;}
			
		ask OCT4 {
			do die;}
			
		ask ZEB {
			do die;}
	}
	
	action create{
		create MDM2 number: num_MDM2 {
			speed <- velocity_proteins;}
		create MIR145 number: num_MIR145 {
			speed <- velocity_proteins;}
		create MIR200 number: num_MIR200 {
			speed <- velocity_proteins;}
		create OCT4 number: num_OCT4 {
			speed <- velocity_proteins;}
		create P53 number: num_P53 {
			speed <- velocity_proteins;}
		create ZEB number: num_ZEB{
			speed <- velocity_proteins;}
		create MIR34 number: num_MIR34{
			speed <- velocity_proteins;}
		create SNAIL number: num_SNAIL{
			speed <- velocity_proteins;}
		create AMPK number: num_AMPK{
			speed <- velocity_proteins;}
		create HIF1 number: num_HIF1{
			speed <- velocity_proteins;}
		create NOXROS number: num_NOXROS{
			speed <- velocity_proteins;}
		create MTROS number: num_MTROS{
			speed <- velocity_proteins;}
		create BACH1 number: num_BACH1{
			speed <- velocity_proteins;}
		create RKIP number: num_RKIP{
			speed <- velocity_proteins;}
		create LET7 number: num_LET7{
			speed <- velocity_proteins;}
		create LIN28 number: num_LIN28{
			speed <- velocity_proteins;}
	}
}

species BACH1 skills: [moving]{
	/*
	 * 1140 min BACH1,LET7=red
	 */
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {	
   		draw circle(size) color: #brown;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_BACH1){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in LET7 or partner in BACH1){
    				do die;}
    			}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

species RKIP skills: [moving]{
	/*
	 * 30 min SNAIL, BACH1=red
	 */
	  int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #turquoise;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_RKIP){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in SNAIL or partner in BACH1){
    				do die;}
    			}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
				   
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

species LET7 skills: [moving]{
	/*
	 * 7200 min LET7,RKIP=green LIN28=red
	 */
	  int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #yellowgreen;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_LET7){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in LIN28){
    				do die;}
    			else if (partner in LET7 or partner in RKIP){
    				create LET7 number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;}}}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
				   
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

species LIN28 skills: [moving]{
	/*
	 * 720 min LET7, MIR200=red LIN28=green
	 */
	  int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #gold;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_LIN28){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in LET7 or partner in MIR200){
    				do die;}
    			else if (partner in LIN28){
    				create LIN28 number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;}}}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			 
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
				    
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}	

//------------------------------------------------------------------------------------
species AMPK skills: [moving]{
	/* 
	*120-240 min	AMPK,HIF1=red MTROS,NOXROS=green
	*/
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	float duration;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;
			duration<-rnd(time_AMPK_min,time_AMPK_max);
			}}
	
	aspect default {
   		draw circle(size) color: #dimgray;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>duration){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{	
    	if (bonded=true){
    		if (cycle-bonded_st=1){
    			if (partner in AMPK or partner in HIF1){
    				do die;}
    			else if (partner in MTROS or partner in NOXROS){
    			//write string(self)+"-"+partner+"-bst-"+bonded_st+"-st-"+st+" ::::"+bonded;
    				create AMPK number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;
						duration<-rnd(time_AMPK_min,time_AMPK_max);}	
    			}
    		}
    		else if (cycle-bonded_st>=10){
	    		bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   
			   		bool flag;
			   		agent s<-self;
			   		ask a{
			   			flag<-bonded;}
					if (!flag){
						speed<-0.0;
					    bonded<-true;
					    bonded_st<-cycle;
					    partner<-a;
					    
					    ask a{
					    	speed<-0.0;
					      	partner<-s;
					      	bonded<-true;
					      	bonded_st<-cycle;}
						break;}
				  
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

species HIF1 skills: [moving]{
	/*
	 * 5-8 min AMPK,P53=red HIF1,NOXROS,MTROS=green
	 */
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	float duration;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;
			duration<-rnd(time_HIF1_min,time_HIF1_max);
			}}
	
	aspect default {
   		draw circle(size) color: #skyblue;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>duration){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{	
    	if (bonded=true){
    		if (cycle-bonded_st=1){
    			if (partner in P53 or partner in AMPK){
    				do die;}
    			else if (partner in HIF1 or partner in MTROS or partner in NOXROS){
    			//write string(self)+"-"+partner+"-bst-"+bonded_st+"-st-"+st+" ::::"+bonded;
    				create HIF1 number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;
						duration<-rnd(time_HIF1_min,time_HIF1_max);}	
    			}
    		}
    		else if (cycle-bonded_st>=10){
	    		bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   	
			   		bool flag;
			   		agent s<-self;
			   		ask a{
			   			flag<-bonded;}
					if (!flag){
						speed<-0.0;
					    bonded<-true;
					    bonded_st<-cycle;
					    partner<-a;
					    
					    ask a{
					    	speed<-0.0;
					      	partner<-s;
					      	bonded<-true;
					      	bonded_st<-cycle;}
						break;}
				  
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

species NOXROS skills: [moving]{
	/*
	 *  AMPK=red HIF1=green
	 */
	 int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #magenta;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_NOXROS){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in AMPK){
    				do die;}
    			else if (partner in HIF1){
    				create MIR34 number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;}}}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			  
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
				   
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

species MTROS skills: [moving]{
	/*
	 * AMPK=green&red HIF1=red
	 */
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #maroon;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_MTROS){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in AMPK){
    				create MTROS number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;}
				if (partner in AMPK or partner in HIF1){
    				do die;}}}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   	
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
				    
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

//------------------------------------------------------------------------------------
species MIR34 skills: [moving]{	
	/* 
	*25min	SNAIL,ZEB-red	P53- green
	*/
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #white;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_MIR34){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in SNAIL or partner in ZEB){
    				do die;}
    			else if (partner in P53){
    				create MIR34 number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;}}}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			  
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
				    
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

species SNAIL skills: [moving]{	
	/* 
	*25min	MIR34,LET7,SNAIL- red
	*/
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #darkorange;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_SNAIL){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in SNAIL or partner in MIR34 or partner in LET7){
    				do die;}
    			}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			  
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
				    
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}

//----------------------------------------------------------------------------------------------
species MDM2 skills: [moving]{	
	/* 
	*25min	MIR145-red	P53- green
	*/
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #blue;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>=time_MDM2){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{
    	if (bonded){
    		if (cycle-bonded_st=1){
    			if (partner in MIR145){
    				do die;}
    			else if (partner in P53){
    				create MDM2 number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;}}}
    		else if (cycle-bonded_st>=10){
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   
			   		agent s<-self;
			   		bool flag;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
						   	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					     
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 	break;}
				    
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}//endMDM2

species MIR145 skills: [moving]{	
	/*
	 * 120hr=7200 min	OCT4,ZEB- red	P53- green	
	 */
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	 init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #darkgreen;}
   		
	reflex move {
		do wander;}
		
   reflex die{
    	ask self{
    		if (cycle-st>=time_MIR145){
    			do die;}}}
    			
    reflex scan_or_interact{
    	ask self{
    		if (bonded){
    			//write string(self)+"-"+partner;
    		//write "standby cycle"+cycle+"- "+bonded_st+"="+int(cycle-bonded_st);
    			if (cycle-bonded_st=1){
    				if (partner in OCT4 or partner in ZEB){
    					do die;}
    				else if (partner in P53){
    					create MIR145 number:1{
	    					location<-any_location_in(world);
	    					speed <- velocity_proteins;
	    					st<-cycle;
							bonded<-false;
							bonded_st<-nil;
							partner<-nil;}}}
    			else if (cycle-bonded_st>=10){
    				bonded<-false;
    				partner<-nil;
    				bonded_st<-nil;
    				speed<-velocity_proteins;}
    		}
    		else{//not bonded
	    		//Scanning for Protein Interaction
				list neighbors<- agents_at_distance(distance);
				loop a over: neighbors {
			      
						bool flag;
						agent s<-self;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){
							
			      			speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;		
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						break;}
				   
			    }//endloopneighbor	
    		}
    	}//end ask  
    }//endreflex 
}//endMIR145

species MIR200 skills: [moving]{	
	/*
	*120hr =7200min
	OCT4-,P53- green ZEB,SNAIL -red
	 */
	 
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	 init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #darkviolet;}
   		
	reflex move {
		do wander;}
		
   reflex die{
    	ask self{
    		if (cycle-st>=time_MIR200){
    			do die;}}}
    
    reflex scan_or_interact{
    	
    	ask self{
    		//	write string(self)+"-"+partner+"-bst-"+bonded_st+"-st-"+st+" ::::"+bonded;	    	
    		if (bonded){
    			if (cycle-bonded_st=1){
    				 if (partner in ZEB or partner in SNAIL ){
    				 	do die;
    				 }
    				 else if (partner in P53 or partner in OCT4){
    					create MIR200 number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;}}}
    			else if (cycle-bonded_st>=10){
    				bonded<-false;
    				partner<-nil;
    				bonded_st<-nil;
    				speed<-velocity_proteins;}
    		}
    		else{//not bonded
	    		//Scanning for Protein Interaction
				list neighbors<- agents_at_distance(distance);
				loop a over: neighbors {
			     
			      		agent s<-self;
				      	bool flag;
			   			ask a{
			   				flag <- bonded;}
						if (!flag){
					      	speed<-0.0;
					      	bonded<-true;
					      	bonded_st<-cycle;
					      	partner<-a;
					      			
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						 break;}
				    
			    }//endloopneighbor	
    		}
    	}//endifbonded
    }//endreflex
}//endMIR200

species OCT4 skills: [moving]{	
	/*
	 * 7.34hr=440.4 min
		MIR145,P53- red  OCT4,LIN28- green
	 */
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	
	 init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;}}
	
	aspect default {
   		draw circle(size) color: #black;}
   		
	reflex move {
		do wander;}
		
   reflex die{
    	ask self{
  			if (cycle-st>=time_OCT4){
    			do die;}}}
    
    reflex scan_or_interact{
    	ask self{
    		if (bonded){
    			if (cycle-bonded_st=1){
    				if (partner in MIR145 or partner in P53){
    					do die;}
    				else if (partner in OCT4 or partner in LIN28){
    					ask partner{
    						bonded<-false;
    					}
    					create OCT4 number:1{
	    					location<-any_location_in(world);
	    					speed <- velocity_proteins;
	    					st<-cycle;
							bonded<-false;
							bonded_st<-nil;
							partner<-nil;}}}
    			else if (cycle-bonded_st>=10){
    				bonded<-false;
    				partner<-nil;
    				bonded_st<-nil;
    				speed<-velocity_proteins;}
    		}
    		else{//not bonded
	    		//Scanning for Protein Interaction
				list neighbors<- agents_at_distance(distance);
				loop a over: neighbors {
			      	
				    bool flag;
				    agent s<-self;
			   		ask a{
			   			flag <- bonded;}
					if (!flag){
						speed<-0.0;
					    bonded<-true;
					    bonded_st<-cycle;
					   	partner<-a;  			
					   ask a{
					   		speed<-0.0;
					      	partner<-s;
					      	bonded<-true;
					      	bonded_st<-cycle;}
					break;}
				   
			   }//endloopneighbor	
    		}
    	}//endifbonded
    }//endreflex
}//endOCT4

/*
	 * 5-20min
	 * 24h=1440 min
	   MDM2- red AMPK,HIF1- green 
	 */
	 
species P53 skills: [moving]{	
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	float duration;
	
	//initial variables (OOP)
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;
			duration<-rnd(time_P53_min,time_P53_max);}}
	
	aspect default {
   		draw circle(size) color: #red;}
   	
   	//random walk
	reflex move {
		do wander;}
	
	//die if their duration or half-life is up
    reflex die{
    	ask self{
    		if (cycle-st>duration){
    			do die;}}}
 
 	//interaction and scanning
    reflex scan_or_interact{
    ask self{	
    	if (bonded=true){//bounded
    		if (cycle-bonded_st=1){
    			if (partner in MDM2){//inhibitions
    					do die;}
    			else if (partner in AMPK or partner in HIF1){//activations
    				duration<-time_P53_activated;
    				st<-cycle;
    				create P53 number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;
						duration<-time_P53_activated;
						}}}
    		else if (cycle-bonded_st>=10){
    			//unbinding
    			bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   		bool flag;
			   		agent s<-self;
			   		ask a{
			   			flag <- bonded;}
						if (!flag){ 
						 	speed<-0.0;
					     	bonded<-true;
					     	bonded_st<-cycle;
					      	partner<-a;
					      	ask a{
					      		speed<-0.0;
					      		partner<-s;
					      		bonded<-true;
					      		bonded_st<-cycle;}
						break;}
				    
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}//endP53

species ZEB skills: [moving]{	
	/*
	 * 44h-68h
	 *2640-4080 min
	MIR145, MIR200- red
	ZEB,HIF1,SNAIL -green
	
	*/
	int st;
	bool bonded<-false;
	int bonded_st;
	agent partner<-nil;
	float duration;
	
	init{
		ask self{
			st<-0;
			bonded<-false;
			bonded_st<-nil;
			partner<-nil;
			duration<-rnd(time_ZEB_min,time_ZEB_max);
			}}
	
	aspect default {
   		draw circle(size) color: #yellow;}
   		
	reflex move {
		do wander;}
	
    reflex die{
    	ask self{
    		if (cycle-st>duration){
    			do die;}}}
 
    reflex scan_or_interact{
    ask self{	
    	if (bonded=true){
    		if (cycle-bonded_st=1){
    			if (partner in MIR145 or partner in MIR200){
    				do die;}
    			else if (partner in ZEB or partner in SNAIL or partner in HIF1){
    			//write string(self)+"-"+partner+"-bst-"+bonded_st+"-st-"+st+" ::::"+bonded;
    				create ZEB number:1{
    					location<-any_location_in(world);
    					speed <- velocity_proteins;
    					st<-cycle;
						bonded<-false;
						bonded_st<-nil;
						partner<-nil;
						duration<-rnd(time_ZEB_min,time_ZEB_max);}	
    			}
    		}
    		else if (cycle-bonded_st>=10){
	    		bonded<-false;
	    		partner<-nil;
	    		bonded_st<-nil;
	    		speed<-velocity_proteins;}
    	}
    	else{//not bonded
	    	//Scanning for Protein Interaction
			list neighbors<- agents_at_distance(distance);
			loop a over: neighbors {
			   
			   		bool flag;
			   		agent s<-self;
			   		ask a{
			   			flag<-bonded;}
					if (!flag){
						speed<-0.0;
					    bonded<-true;
					    bonded_st<-cycle;
					    partner<-a;
					    
					    ask a{
					    	speed<-0.0;
					      	partner<-s;
					      	bonded<-true;
					      	bonded_st<-cycle;}
						break;}
				  		
			     }//endloopneighbor	
    		}//endelse
    	}//endifbonded
    }//endreflex
}//endZEB

global{
	/*action capture{
		// MDM2 to: " save_shapefile .shp" type:"shp" attributes:[name::"nameAgent ",location::"locationAgent"] crs:" EPSG :4326 ";
		//save (string(cycle)) to: "im.txt" type: "text";
		save (string(21)) to: "img/save_grid.png" type: "image";
		write 12;
	}*/
	
	date Itime;
	reflex record{
		 save [cycle] to: "save_data" type: "csv" rewrite: false ;
		if (cycle=1){
			Itime<-#now;
		}
        if (cycle=5){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes05.txt" type: "text";
        }
        else if (cycle mod 10=0){
        	do pause;
        }
        else if (cycle=10){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes10.txt" type: "text";
        }
        
         else if (cycle=15){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes15.txt" type: "text";
        }
        
         else if (cycle=20){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes20.txt" type: "text";
        	
        }
        
        else if (cycle=30){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes30.txt" type: "text";
        }
        
         else if (cycle=40){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes40.txt" type: "text";
        }
        
         else if (cycle=50){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	string dat<-("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB)));
        	save dat to: "record/minutes50.txt" type: "text";
        	
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/sample.csv" type: "csv" rewrite:true;
        	
        }
        
         else if (cycle=60){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes60.txt" type: "text";
        }
        
        else if (cycle=120){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"	\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes120.txt" type: "text";
        	 
        }
        
        else if (cycle=300){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes300.txt" type: "text";
        	 
        }
        
        else if (cycle=600){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"	\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes600.txt" type: "text";
        	 
        }
        
        else if (cycle=1200){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes1200.txt" type: "text";
        	 
        }
        
        else if (cycle=1800){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"	\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes1800.txt" type: "text";
        	 
        }
        
        else if (cycle=2400){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes2400.txt" type: "text";
        	 
        }
        else if (cycle=3600){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes3600.txt" type: "text";
        	 do pause;
        }
        else if (cycle=6000){
        	date Ctime <-#now;
        	int Rtime<-int(Ctime-Itime);
        	save ("Real time:"+Rtime+"\nMDM2="+string(length(MDM2))+"\nMIR145="+string(length(MIR145))+
        	"\nMIR200="+string(length(MIR200))+"\nOCT4="+string(length(OCT4))+"\nP53="+string(length(P53))+
        	"\nZEB="+string(length(ZEB))) to: "record/minutes6000.txt" type: "text";
        	 do pause;
        }
       
    }
    }

experiment Proteins_interactions_inside_cancer_cell type: gui {
	/*parameter "Number of P53" var:num_P53;
	parameter"Number of MIR145" var:num_MIR145;
	parameter"Number of MIR200" var: num_MIR200; 
	parameter"Number of MDM2" var: num_MDM2; 
	parameter"Number of OCT4" var: num_OCT4; 
	parameter"Number of ZEB" var: num_ZEB; 
	
	parameter"Number of OCT4" var: num_SNAIL; 
	parameter"Number of ZEB" var: num_MIR34; 
	
	user_command "Create New Cells" {
		ask world{
			do clean;
			do create;
		}
	}
	*/
	output {
		
		monitor "Current cycle" value: cycle;	
		monitor "MDM2(blue):" value: length(MDM2);
		monitor "MIR145(darkgreen):" value: length(MIR145);	
		monitor "MIR200(darkviolet):" value: length(MIR200);	
		monitor "OCT4(black):" value: length(OCT4);	
		monitor "P53(red):" value: length(P53);	
		monitor "ZEB(yellow):" value: length(ZEB);	
		
		monitor "MIR34(white):" value: length(MIR34);	
		monitor "SNAIL(darkorange):" value: length(SNAIL);	
		
		monitor "AMPK(dimgray):" value: length(AMPK);	
		monitor "HIF1(skyblue):" value: length(HIF1);	
		monitor "MTROS(maroon):" value: length(MTROS);	
		monitor "NOXROS(magenta):" value: length(NOXROS);	
		
		monitor "LET7(yellowgreen):" value: length(LET7);	
		monitor "BACH1(brown):" value: length(BACH1);	
		monitor "RKIP(turquoise):" value: length(RKIP);	
		monitor "LIN28(gold):" value: length(LIN28);	
		
		display proteins background:#lightslategrey virtual: false{
			species MDM2;
			species MIR145;
			species MIR200;
			species OCT4;
			species P53;
			species ZEB;
			
			species SNAIL;
			species MIR34;
			
			species BACH1;
			species LET7;
			species LIN28;
			species RKIP;
			
			species NOXROS; 
			species MTROS;
			species AMPK; 
			species HIF1;
		}

		display chart refresh: every(1 #cycles) {
			chart "Number of Protein vs. Time"  style:exploded type: series background:#lightgray axes:#black{
				data "MDM2" value: length(MDM2) color: #blue marker: false;
				data "MIR145" value: length(MIR145) color: #darkgreen marker: false;
				data "MIR200" value: length(MIR200) color: #darkviolet marker: false;
				data "OCT4" value: length(OCT4) color: #black marker:false;
				data "P53" value: length(P53) color: #red marker: false;
				data "ZEB" value: length(ZEB) color: #yellow marker: false;
				
				data "SNAIL" value: length(SNAIL) color: #darkorange marker: false;
				data "MIR34" value: length(MIR34) color: #white marker: false;
				
				data "AMPK" value: length(AMPK) color: #dimgray marker: false;
				data "HIF1" value: length(HIF1) color: #skyblue marker: false;
				data "MTROS" value: length(MTROS) color: #maroon marker: false;
				data "NOXROS" value: length(NOXROS) color: #magenta marker: false;
				
				data "LET7" value: length(LET7) color: #yellowgreen marker: false;
				data "LIN28" value: length(LIN28) color: #gold marker: false;
				data "BACH1" value: length(BACH1) color: #brown marker: false;
				data "RKIP" value: length(RKIP) color: #turquoise marker: false;
			}
			}
		
	}
}