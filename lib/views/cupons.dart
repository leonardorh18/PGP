import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teste/DAO/CupomDAO.dart';
import 'package:teste/DAO/TarefaDAO.dart';
import 'package:teste/models/Cupom.dart';
import 'package:teste/Utils/utils.dart';
import 'package:teste/models/Tarefa.dart';
import 'package:teste/views/widgets/cupom_dialog.dart';

class ListCupons extends StatefulWidget {
  @override
  _ListCuponsState createState() => _ListCuponsState();
}

class _ListCuponsState extends State<ListCupons> {
  List <Cupom> listaCupons = [];
  Utils utils = Utils();
  CupomDAO cupomDAO = CupomDAO();
  bool carregando = true;
  TarefaDAO tarefaDAO = TarefaDAO();
  CupomDialog cupomDialog = CupomDialog();

  final spinkit = SpinKitWanderingCubes(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.red,
      ),
    );
  },
);

  buscarCupons() async {

    listaCupons = await cupomDAO.getCupons();
    //print('TAMANHO '+ listaCupons.length.toString());
    setState(() {
      carregando = false;
    });

  }

  @override
  void initState()  {    
    buscarCupons(); 
    super.initState();
  }
  
  Widget build(BuildContext context) {
    return carregando ? spinkit : Container(

        child: Column(
        children: [
            Container(
              child: Column(
                children: [
                       Padding(padding: EdgeInsets.fromLTRB(20, 18, 10, 3),
                       child:Align(
                         alignment: Alignment.centerLeft,
                         child:Text('Olá Fulano,',
                            style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black)
                            )
                       ),),

                       Padding(
                         padding: EdgeInsets.fromLTRB(20, 3, 10,50),
                         child: Align(
                         alignment: Alignment.centerLeft,
                         child:Text('Veja os cupons que separamos para você!',
                            style: GoogleFonts.montserrat(fontSize: 17, color: Colors.black)
                            )
                       ),
                       )
                ],
              )
            ),
            Flexible( child: ListView.builder(
              itemCount: listaCupons.length,
              itemBuilder: (context, index){

              Cupom cupom = listaCupons[index];

              return Card(
              color: Colors.red,
              elevation: 10,
              margin: EdgeInsets.fromLTRB(30, 7, 0, 5),

              shape: BeveledRectangleBorder(
                borderRadius:BorderRadius.only(
                   bottomLeft: Radius.circular(15,),
                   topLeft: Radius.circular(15,),
                ),
              ),
              
              child: InkWell( 
              onTap: () async{
                utils.loading(context);
                cupomDialog.detalheCupom(cupom, context);
              },
              child: Container(
              
              child: Row(
                children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                      ),

                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        
                        child: ClipRect(
                          child: Image.network(
                            cupom.link_imagem.toString(),
                            height: 100,
                            width: 100,
                            fit: BoxFit.fitHeight, 
                          ),
                        ),
                        )
                      ),

                    DottedLine(
                      dashLength: 10,
                      dashGapLength: 10,
                      lineThickness: 4,
                      dashColor: Colors.white,
                      direction: Axis.vertical,
                      lineLength: 130,
                    ),

                    SizedBox(width: 10,),

                    Expanded(child: Column(
                      children: [
                       Align(
                         alignment: Alignment.centerLeft,
                         child:Text(cupom.estabelecimento.nome.toString(),
                            style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)
                            )
                       ),
                          
                        SizedBox(height: 7,),

                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('${cupom.estabelecimento.rua} - ${cupom.estabelecimento.numero}, ${cupom.estabelecimento.bairro} - 0.0km',
                          style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic,color: Colors.white) //TextStyle( color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13),),
                          )
                        ),
                          
                      SizedBox(height: 12,),

                      Align(
                        alignment: Alignment.centerRight,
                        child:Text('${cupom.nome_produto} - ${cupom.porc_desconto.toInt()}% off',
                          style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white))
                      ),

                      SizedBox(height: 10,),

                      Align(
                        alignment: Alignment.centerRight,
                        child:Text('Por R\$'+ (cupom.preco * (1 - (cupom.porc_desconto/100))).toStringAsFixed(2) ,
                          style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                      
                      SizedBox(height: 10,),
                        
                                               
                      ],
                    )
                    ),
                    SizedBox(width: 5,),


                ],
              ),
              ),
              )
            );


            }) 
            )
            

        ],
      ),
    );
  }
}