class Current {

    constructor(cur, sum){
      this.cur = cur;
      this.sum = sum;
    }

    to_format() {
        let result;
        switch(this.cur) {
            case 'RUB':
                result = this.rub();
                break;
            case 'AUD':
                result = this.aud();
                break;
            case 'EUR':
                result = this.eur();
                break;
            case 'USD':
                result = this.usd();
                break;
            case 'INR':
                result = this.inr();
                break;
            case 'CAD':
                result = this.cad();
                break;
            default:
                result = this.aud();
                break;
        }
            return result;
    }

    eur(){
        return `€${this.sum}`
    }

    rub(){
        return `${this.sum} RUB`
    }

    aud(){
        return `$${this.sum}`
    }

    usd() {
        return `$${this.sum}`
    }

    inr() {
        return `${this.sum} INR`
    }

    cad() {
        return `$${this.sum}`
    }

}