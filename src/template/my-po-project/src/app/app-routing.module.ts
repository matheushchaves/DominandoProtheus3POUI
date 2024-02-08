import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CrudComponent } from './crud/crud.component';
import { AppComponent } from './app.component';

const routes: Routes = [
  { path: '*',  component: AppComponent },
  { path: 'home',  component: AppComponent },
  { path: 'crud',  component: CrudComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
