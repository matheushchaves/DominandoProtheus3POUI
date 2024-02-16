import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { PoMenuItem } from '@po-ui/ng-components';
import { ProAppConfigService } from '@totvs/protheus-lib-core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {

  constructor(private router: Router, private proAppConfigService: ProAppConfigService) { }

  ngOnInit(): void {
    if (this.proAppConfigService.insideProtheus()) {
      this.proAppConfigService.loadAppConfig();
    } else {
      const config = {
        "name": "MyPoProject",
        "version": "1.0.0",
        "serverBackend": "http://localhost:8081",
        "restEntryPoint": "/api",
        "versionAPI": "1",
        "productLine": "poui",
        "api_baseUrl": "http://localhost:8081/rest"
      }

      sessionStorage.setItem('ERPAPPCONFIG', JSON.stringify(config));
    }
  }
  readonly menus: Array<PoMenuItem> = [
    { label: 'Home', action: () => this.router.navigate(['home']) },
    { label: 'CRUD', action: () => this.router.navigate(['crud']) },
    { label: 'Sair', action: this.closeApp.bind(this) }
  ];

  private onClick() {
    alert('Clicked in menu item')
  }
  private closeApp() {
    if (this.proAppConfigService.insideProtheus()) {
      this.proAppConfigService.callAppClose(true);
    } else {
      alert('O App não está sendo executado dentro do Protheus.');
    }
  }
}
