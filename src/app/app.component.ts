import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent {
  title = 'Ana Caroline Cagliari Cappellari';

  getBuildInfo(): string {
    const now = new Date();
    const buildDate = now.toLocaleDateString('pt-BR');
    const buildTime = now.toLocaleTimeString('pt-BR');
    return `${buildDate} às ${buildTime}`;
  }

  getEnvironment(): string {
    return 'Produção - AWS EC2';
  }

  getPipelineStatus(): string {
    return 'Ativo e Funcionando';
  }
}
