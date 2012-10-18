document.observe('dom:loaded', function(){
	var end=0;
	if ($('e_q_mine_issues'))
		{
		$('e_q_mine_issues').nextSiblings().each(function(e){
			if(end==0)
				{	
				if((e.tagName=='A')||(e.tagName=='BR'))	
					{
					 $('e_q_mine_issues').insert({before: e});
					}
				else
					end=1
				}
			});
		}
	
	});