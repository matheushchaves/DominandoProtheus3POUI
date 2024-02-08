import { Component } from '@angular/core';
import { PoTableColumn } from '@po-ui/ng-components';

@Component({
  selector: 'app-crud',
  templateUrl: './crud.component.html',
  styleUrls: ['./crud.component.css']
})
export class CrudComponent {
  filteredColumns: Array<string> = [ 'c0a_id', 'c0a_codigo', 'c0a_exncm', 'c0a_descri', 'c0a_perncm', 'c0a_valida', 'c0a_stamp']
  columns: Array<PoTableColumn> = [
    { property: 'c0a_filial', label: 'Filial', type: 'string' },
    { property: 'c0a_id', label: 'ID', type: 'string' },
    { property: 'c0a_codigo', label: 'Cod. NCM', type: 'string' },
    { property: 'c0a_exncm', label: 'Ex-NCM', type: 'string' },
    { property: 'c0a_descri', label: 'Descr NCM', type: 'string' },
    { property: 'c0a_perncm', label: 'Percentual', type: 'string' },
    { property: 'c0a_valida', label: 'Data Vigenc.', type: 'string' },
    { property: 'c0a_stamp', label: 'Stamp', type: 'string' }
  ]
}
