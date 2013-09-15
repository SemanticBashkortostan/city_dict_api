#encoding "utf-8"    // сообщаем парсеру о том, в какой кодировке написана грамматика
#GRAMMAR_ROOT S      // указываем корневой нетерминал грамматики

Letter  -> AnyWord<wfm=/[А-Я]\./>;

Name -> AnyWord<gram="имя"> | Noun<kwtype="башИмя">;
Surname -> AnyWord<gram="фам"> | Noun<kwtype="башФам"> | Adj<kwtype="башФам">;

Person -> Surname<gnc-agr[2]> Name<gnc-agr[2]> 
	| Name<gnc-agr[1]> Surname<gnc-agr[1]> 
	| Surname<gnc-agr[2]> Name<gnc-agr[2]> AnyWord<gram="отч">
	| Name<gnc-agr[1]> AnyWord<gram="отч"> Surname<gnc-agr[1]> 
	| Surname Letter Letter
	| Letter Letter Surname;

Naming -> AnyWord<quoted> | Word<l-quoted> Property* AnyWord<r-quoted>;


Participate -> "принять" "участие"| "принимать" "участие" |"участвовать" ;

Pass -> "пройти" | "состояться" | "стартовать" | "начаться" | "закончиться";

Property -> Adj<gnc-agr[2]>* Noun<GU="~им",gnc-agr[2]>+;
Event -> Adj<gram="nom">* Noun<gram="nom"> Property* Naming;
EventMain -> Noun<gram="местн"> | Noun<gram="пр">;
Event2 -> Adj<gnc-agr[2]>* EventMain<gnc-agr[2]> Property* Naming; 
In -> "в" | "во";
Feed -> AnyWord<wfm=/feed\d+/>;

OrganizationPrefix -> "организация" | "завод" | "компания" | "фирма" | "концерн" | "ОАО" | "ООО" | "ЗАО" | "МУП";
Organization -> OrganizationPrefix Naming;
PlacePrefix -> "парк" | "дом" | "комплекс" | "дворец" | "стадион" | "тк" | "трк" | "санаторий" | "зал"; 

Place1 -> Adj<gnc-agr[2]>* PlacePrefix<gnc-agr[2]> Noun<GU="~им">* Naming;

S -> Noun<kwtype="город"> interp(Fact.type="city"; Fact.data)
 | Person interp(Fact.type="person"; Fact.data) 
 | (Event interp(Fact.data;Fact.type="event")) Pass  
 | Pass (Event interp(Fact.data; Fact.type="event")) 
 | Participate In (Event2 interp(Fact.data; Fact.type="event"))
 | Feed interp(Fact.type="feed"; Fact.data) 
 | Organization interp(Fact.type="organization"; Fact.data)
 | Place1 interp(Fact.type="place"; Fact.data);
