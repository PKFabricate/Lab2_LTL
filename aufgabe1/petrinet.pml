/* 
  petrinet.pml
  Modelierung des Keks-Automat Petri-Netzes in Promela.
  FMiSE, Lab 1, Aufgabe 1
*/

#define PLACES_COUNT 5
short places [PLACES_COUNT] = {
// Geldbörse
#define WALLET 0
    3,
// Geld-Einwurfschlitz
#define MONEY_SLOT 1
    0,
// Keksspeicher
#define COOKIE_STORAGE 2
    2,
// Keks-Entnahmefach
#define COOKIE_OUT 3
    0,
// interne Kasse
#define CASH_BOX 4
    0
}

short transition = 0;
#define TRANS_MONEY_IN  1
#define TRANS_MONEY_OUT 2
#define TRANS_BUY       3
#define TRANS_EAT       4
#define TRANS_SKIP      5

inline transIn(place) {
    places[place] > 0;
    places[place] --
}

inline transOut(place) {
    places[place] ++
}

active proctype PetriNet() {

   do
   :: atomic {
         transIn(WALLET);
         transOut(MONEY_SLOT)
      };
      transition = TRANS_MONEY_IN;
      printf("Geld-Einwurf\n")
   :: atomic {
         transIn(MONEY_SLOT);
         transOut(WALLET)
      };
      transition = TRANS_MONEY_OUT;
      printf("Geld-Rückgabe\n")
   :: atomic {
         places[MONEY_SLOT] >= 1 && places[COOKIE_STORAGE] >= 1;
         transIn(MONEY_SLOT);
         transIn(COOKIE_STORAGE);
         transOut(COOKIE_OUT);
         transOut(CASH_BOX)
      };
      transition = TRANS_BUY;
      printf("Kaufaktion\n")
   :: atomic {
         transIn(COOKIE_OUT);
      };
      transition = TRANS_EAT;
      printf("Keks-Essen\n")
   :: true;
      transition = TRANS_SKIP;
      printf("Skip\n")
   od
}
ltl NoMoneyNoCookie {[]transition!=TRANS_MONEY_IN -> []transition!=TRANS_EAT}
ltl NoCashBackAlwaysSkip {[]transition!=TRANS_MONEY_OUT -> <>[]transition==TRANS_SKIP}
ltl AlwaysCashBackNeverFills {[](transition==TRANS_MONEY_IN U transition==TRANS_MONEY_OUT)->places[CASH_BOX]==0}
//Remember: Only one claim can be verified at a time.