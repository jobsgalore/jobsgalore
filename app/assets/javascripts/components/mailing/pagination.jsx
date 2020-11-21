class Pagination extends React.Component {
    constructor(props) {
        super(props);
        this.onClick = this.onClick.bind(this);
    }

    onClick(index){
        this.props.onClickPage({page: index})
    }

    render() {
        let funTwoButton = function () {
            let rez;
            if ( this.props.page_count <= 5 && this.props.page <= 4 || this.props.page_count > 5 && this.props.page <= 2) {
                rez = 1;
            }else if(this.props.page_count > 5 && (this.props.page > 1  && this.props.page <= this.props.page_count-4)){
                rez = this.props.page - 1;
            } else if(this.props.page_count > 5 &&  this.props.page >= this.props.page_count-4) {
                rez = this.props.page_count -4;
            }
            return(rez)
        }.bind(this);
        let funThreeButton = function () {
            let rez;
            if (this.props.page_count <= 5 && this.props.page <= 4 || this.props.page_count > 5 && this.props.page <= 2){
                rez = 2;
            } else if(this.props.page > 2  && this.props.page <= this.props.page_count-4) {
                rez = this.props.page;
            } else if(this.props.page >=this.props.page_count-4) {
                rez = this.props.page_count-3;
            }
            return(rez)
        }.bind(this);
        let funFourButton = function () {
            let rez;
            if (this.props.page_count <= 5 && this.props.page <= 4 || this.props.page_count > 5 &&  this.props.page < 3){
                rez = 3;
            } else if(this.props.page >= 3 && this.props.page <= this.props.page_count-3) {
                rez = this.props.page +1;
            } else if(this.props.page >=this.props.page_count-3) {
                rez = this.props.page_count-2;
            }
            return(rez)
        }.bind(this);
        let paginate =  [];
        if (this.props.page_count>1) {
            paginate.push(<li key = "0" className={this.props.page === 0 ? "active" : null}><a
               onClick={() => this.onClick(0)}>1</a></li>);
            if (this.props.page_count >= 2) {
                if (this.props.page_count > 5 && this.props.page > 2) {
                    paginate.push(<li key = "empty1"><a>...</a></li>)
                }
                paginate.push(<li key = "1" className={this.props.page === 1 ? "active" : null}><a
                    onClick={() => this.onClick(funTwoButton())}>{funTwoButton()+1}</a>
                </li>);
                if (this.props.page_count >= 3) {
                    paginate.push(<li key = "2" className={this.props.page_count <= 5 && this.props.page === 2 || this.props.page_count > 5 && this.props.page >= 2 && this.props.page + 1 <= this.props.page_count - 2 ? "active" : null}><a
                        onClick={() => this.onClick(funThreeButton())}>{funThreeButton() + 1}</a>
                    </li>);
                    if (this.props.page_count >= 4) {
                        paginate.push(<li key = "3" className={this.props.page_count <= 5 && this.props.page === 3 || this.props.page_count > 5 && this.props.page + 1 === this.props.page_count -1 ? "active" : null}><a
                            onClick={() => this.onClick(funFourButton())}>{funFourButton()+ 1}</a>
                        </li>);
                        if ( this.props.page_count > 5 && this.props.page < this.props.page_count - 3) {
                            paginate.push(<li key = "empty2"><a>...</a></li>)
                        }
                        if (this.props.page_count >= 5) {
                            paginate.push(<li key = "4" className={this.props.page + 1 === this.props.page_count ? "active" : null} ><a
                                onClick={() => this.onClick(this.props.page_count - 1)}>{this.props.page_count}</a>
                            </li>);
                        }
                    }
                }
            }

        }
        return(<div className="text-center">
                    <ul className="pagination pagination">
                        {paginate}
                    </ul>
                </div>);
    }

}
