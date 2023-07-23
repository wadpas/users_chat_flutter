import { Component, OnInit } from "@angular/core";

const ROWS_HEIGT: { [id: number]: number } = { 1: 400, 3: 350, 4: 300 };

@Component({
  selector: "app-home",
  templateUrl: "./home.component.html",
})
export class HomeComponent implements OnInit {
  cols = 3;
  rowHeight = ROWS_HEIGT[this.cols];
  category: string | undefined;

  constructor() {}

  ngOnInit(): void {}

  onColumnsCountChange(colsNumber: number): void {
    this.cols = colsNumber;
    this.rowHeight = ROWS_HEIGT[this.cols];
  }
  onShowCategory(category: string): void {
    this.category = category;
  }
}
