import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CrudComponent } from './crud/crud.component';
import { AppComponent } from './app.component';

const routes: Routes = [
  { path: '',  redirectTo: '/home', pathMatch: 'full' }, // Redireciona a rota inicial para /home
  { path: 'home',  component: AppComponent },  
  { path: 'crud',  component: CrudComponent },
  { path: '**',  component: AppComponent }, // Rota wildcard para capturar qualquer caminho não definido
];
@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
