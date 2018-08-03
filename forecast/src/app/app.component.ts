import { Component } from '@angular/core';
import { Http } from '@angular/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  users = [];
  location: string = "";

  constructor(private http: Http) {
    this.getLocation();
  }

  getLocation() {
    this.http.get('http://localhost:3001/location')
      .subscribe(res => {
        this.location = res.json().location;
      });
  }
}
