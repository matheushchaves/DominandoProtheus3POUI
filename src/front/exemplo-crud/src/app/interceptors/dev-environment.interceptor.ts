import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable()
export class DevEnvironmentInterceptor implements HttpInterceptor {

  constructor() {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    if (environment.development) {
      const devUrl = 'http://localhost:8081/rest'; // Substitua pela URL do seu ambiente de desenvolvimento
      const headers = request.headers.set('Authorization', 'Basic ' + btoa('admin:admin'));
      request = request.clone({
        url: devUrl + request.url,
        headers: headers
      });
    }
    return next.handle(request);
  }
}
