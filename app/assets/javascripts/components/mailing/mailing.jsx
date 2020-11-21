class Mailing extends React.Component{
    constructor(props){
        super(props);
        let resumes = {};
        if (this.props.resumes.length > 0) {
            this.props.resumes.map(function (resume, i) {
                resumes["resume_" + i] = {resume: resume, checked: false};
            }.bind(this));
            resumes.resume_0.checked = true;
        } else {
            resumes = null;
        }

        this.state = {  elements: this.props.elements,
                        filterCheck: false,
                        filterCompany: this.props.filterCompany && this.props.filterCompany.replace(/[\f\n\r\t\v\u00A0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u2028\u2029\u2028\u2029\u202f\u205f\u3000'"]/g, ""),
                        filterOffice:null,
                        filterMain:false,
                        filterAgency:false,
                        filterIndustry:null,
                        filterLocation:null,
                        amount: Number(this.props.amount),
                        price: this.props.minPriceForAd,
                        page_size: PAGE_SIZE.small,
                        page: 0,
                        page_count: Math.ceil(this.props.elements.length / PAGE_SIZE.small),
                        isStepTwo: false,
                        resumes: resumes,
                        view: false,
                        message: "<p>Hi,</p><p>...</p><p>I look forward to hearing from you.</p>"
        };

        this.funDevelopFilter = this.funDevelopFilter.bind(this);
        this.onClickRow = this.onClickRow.bind(this);
        this.onChangePrice = this.onChangePrice.bind(this);
        this.viewElements  = this.viewElements.bind(this);
        this.handleDataUpdate = this.handleDataUpdate.bind(this);
        this.onClickNext = this.onClickNext.bind(this);
        this.sendDateToServer = this.sendDateToServer.bind(this);
    }

    onClickNext(){
        this.setState({isStepTwo: !this.state.isStepTwo})
    }

    sendDateToServer(){
        let letter = { recipients: this.state.elements.filter(elem => elem.check === true).map(function (elem){
                    return({id: elem.id,
                            type_client: elem.type_client});
            }
        ),
                        price: this.state.price,
                        message: this.state.message,
                        type: this.state.view ? this.props.type.resume : this.props.type.ad,
                        cur: this.props.cur
        };
        if (this.state.view){
            letter.resume = Object.values(this.state.resumes).filter(elem => elem.checked === true)[0].resume.id
        }
        $.ajax({
            type: "post",
            url: this.props.route,
            data:   letter,
            success: function (data, textStatus) {
                if (data.url !== null) {
                    window.location.href = data.url;
                }
            }.bind(this),
            dataType: 'json'
        });
        experiment('contacts_of_companies', 'Оплата');
    }


    funDevelopFilter(name){
        let str = "return ";
        let contitions = [];
        if (this.state.filterCheck) {contitions.push(name +".check == "+this.state.filterCheck)}
        if (this.state.filterCompany) {contitions.push(name +".company.toLowerCase().indexOf(\""+this.state.filterCompany.toLowerCase()+"\")>-1")}
        if (this.state.filterOffice) {contitions.push(name +".office.toLowerCase().indexOf(\""+this.state.filterOffice.toLowerCase()+"\")>-1")}
        if (this.state.filterMain) {contitions.push(name +".main == "+this.state.filterMain)}
        if (this.state.filterAgency) {contitions.push(name +".recrutmentagency == "+this.state.filterAgency)}
        if (this.state.filterIndustry) {contitions.push(name +".industry.toLowerCase().indexOf(\""+this.state.filterIndustry.toLowerCase()+"\")>-1")}
        if (this.state.filterLocation) {contitions.push(name +".location.toLowerCase().indexOf(\""+this.state.filterLocation.toLowerCase()+"\")>-1")}
        if (contitions.length === 0) {
            str += name +" !== null";
        } else {
            str += contitions.join(" && ");
        }
        return str;
    }

    onClickRow(elem){
        this.setState({ elements: elem.arrElem,
                        amount:elem.amount,
                        price: this.onChangePrice(elem.amount, this.state.view )});
    }


    handleDataUpdate(data){
        this.setState(data);
    }

    onChangePrice(amount, view = false){
        if (amount===null){
            amount= this.state.amount;
        }

        let priceOfEmail = view ?  this.props.oneEmailForResume : this.props.oneEmailForAd;
        let minPrice = view ?  this.props.minPriceForResume : this.props.minPriceForAd;
        let price_new = amount * priceOfEmail;
        if (price_new < minPrice){
            price_new = minPrice;
        }
        return price_new;
    }

    viewElements(){
        let filters = new Function('obj', this.funDevelopFilter('obj'));
        let rez = this.state.elements.filter(function (elem) {
            return(filters(elem));
        }.bind(this));
        return rez.slice(this.state.page_size * this.state.page, this.state.page_size * (this.state.page + 1));
    }

    render() {
        let price_formatted = new Current(this.props.cur, this.state.price);
        let stepOne = [<MailingListOfCompanies  viewElements = {this.viewElements}
                                                key = {this.viewElements.id}
                                                filterCompany = {this.state.filterCompany}
                                                onChangeFilterState = {this.handleDataUpdate}
                                                onClickRow = {this.onClickRow}
                                                elements = {this.state.elements}
                                                amount = {this.state.amount}/>,
                        <Pagination key = {this.state.page} page_count = {this.state.page_count} page={this.state.page} onClickPage = {this.handleDataUpdate}/>];
        let stepTwo = <StepTwo resumes ={this.state.resumes}
                               seeker = {this.props.seeker}
                               view = {this.state.view}
                               message = {this.state.message}
                               onChangePrice = {this.onChangePrice}
                               updateDate = {this.handleDataUpdate}/>;
        let btn = <div className="row hidden-sm hidden-xs">
                        <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <hr className="colorgraph" />
                        </div>
                        <div className="col-md-offset-6 col-lg-offset-6 col-xs-6 col-md-6">
                            <button className="btn btn-primary btn-block" onClick={this.state.isStepTwo ?  this.sendDateToServer  : this.onClickNext }>{this.state.isStepTwo ? `Send and Pay ${price_formatted.to_format()}` : "Next"}</button>
                        </div>
                   </div>;
        let btn_min = <div className="row sticky hidden-lg hidden-md">
                        <div className="col-xs-12 col-md-12">
                            <button className="btn btn-primary btn-circle btn-block" onClick={this.state.isStepTwo ?  this.sendDateToServer  : this.onClickNext }>{this.state.isStepTwo ? `Send and Pay ${price_formatted.to_format()}` : "Next"}</button>
                        </div>
                    </div>;
        let size = this.state.isStepTwo ? null : <div className="col-lg-5 col-md-5 col-sm-5 col-xs-12">
            <ChangeSize onChangeSize = {this.handleDataUpdate} page_size = {this.state.page_size} length = {this.state.elements.length}/>
        </div>;
        let tab = this.state.isStepTwo  ? null : <ul className="nav nav-tabs">
            <li><a href={this.props.mailbox}>Mailbox</a></li>
            <li className="active"><a>Mailing List</a></li>
        </ul>;
        return (
            <div>

                <div className = "col-lg-8 col-md-9 col-sm-12">

                        <h1>{this.state.isStepTwo ? "Message":"Mailing List"}</h1>
                        {tab}
                        <br/>

                    <div className="row">
                        <div className={this.state.isStepTwo ? "col-lg-12 col-md-12 col-sm-12 col-xs-12":"col-lg-7 col-md-7 col-sm-7 col-xs-12"}>
                            <div className="panel panel-default">
                                <div className="panel-body">
                                    <div className="col-lg-7 col-md-7 col-sm-7 col-xs-12">
                                        <strong>Selected recipients: </strong><span className="badge">{this.state.amount}</span>
                                    </div>
                                    <div className="col-lg-5 col-md-5 col-sm-5 col-xs-12">
                                        <strong>Price: </strong><span className="badge">{price_formatted.to_format()}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {size}
                    </div>
                    {this.state.isStepTwo ? stepTwo : stepOne}
                    {btn}
                    {btn_min}
                    <br />
                </div>
            </div>
        );
    }
}
