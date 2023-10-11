import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';

import { PoBreadcrumb, PoDialogService, PoPageAction } from '@po-ui/ng-components';
import { ProGenericAdapterService, ProAdapterListInterface, ProAdapterQueryInterface } from '@totvs/protheus-lib-core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {

  constructor(
    private dialogService: PoDialogService,    
    private proGenericAdapterService: ProGenericAdapterService,
  ) { }

  public readonly actions: Array<PoPageAction> = [
    { label: 'Incluir', icon: 'po-icon-plus', action: this.openNotification.bind(this) },
  ];

  public readonly breadcrumb: PoBreadcrumb = {
    items: [{ label: 'Home', link: '/' }, { label: 'Exemplo Crud' }]
  };

  public readonly title = 'Exemplo Crud';
  
  public columns: Array<any> = [
    { property: 'id', label: 'Código' },
    { property: 'name', label: 'Nome' },
    { property: 'email', label: 'E-mail' },
  ]

  public  items: Array<any> = [
    { id: 1, name: 'João', email: ''},
    { id: 2, name: 'Maria', email: ''},
  ];

  private openNotification(){
    this.dialogService.alert({
      title: 'Notificação',
      message: 'Você foi notificado!',
    });    
  }

  ngOnInit(): void {
    this.genericListAdapter();
  }

  genericListAdapter(){
    let adapterList: ProAdapterListInterface = {
      alias: 'C0A',
      fields: 'c0a_filial,c0a_id,c0a_codigo,c0a_exncm,c0a_descri,c0a_perncm,c0a_valida,c0a_stamp', 
    };    
    this.proGenericAdapterService.list(adapterList).subscribe({
      next: apiReturn => {
        console.log(apiReturn);
        let propriedades = adapterList.fields?.split(',') ?? [];
        let arrayJSON = propriedades.map((propriedade) => {
          return { property: propriedade };
        });
        
          this.items = apiReturn.items;
          this.columns = arrayJSON;
        }
      }
    );
  }

}
