
class MailingListOfCompanies extends React.Component {
    constructor(props) {
        super(props);
        this._filterCheck = React.createRef();
        this._filterCompany = React.createRef();
        this._filterOffice = React.createRef();
        this._filterMain = React.createRef();
        this._filterAgency = React.createRef();
        this._filterIndustry = React.createRef();
        this._filterLocation = React.createRef();
        this.onChangeFilter = this.onChangeFilter.bind(this);
        this.onClickCheckAll = this.onClickCheckAll.bind(this);

    }

    onChangeFilter(){
        let filter = {
            page: 0,
            filterCheck: this._filterCheck.current.checked,
            filterCompany:  this._filterCompany.current.value,
            filterOffice:this._filterOffice.current.value,
            filterMain:this._filterMain.current.checked,
            filterAgency:this._filterAgency.current.checked,
            filterIndustry:this._filterIndustry.current.value,
            filterLocation:this._filterLocation.current.value
        };
        this.props.onChangeFilterState(filter);
    }

    onClickRow(index){
        let arrElem = this.props.elements;
        let amount = this.props.amount;
        let indexElm = arrElem.findIndex(function (row) {
            return row.index === index
        });
        if (arrElem[indexElm].check){
            arrElem[indexElm].check = false;
            amount-=1;
        } else {
            arrElem[indexElm].check = true;
            amount+=1;
        }
        this.props.onClickRow({ arrElem: arrElem,
            amount:amount});
    }

    onClickCheckAll(event){
        let arrElem = this.props.elements;
        let arrElemViewed = this.props.viewElements();
        let amount = this.props.amount;
        let checked = event.target.checked;
        arrElemViewed.forEach(function (row) {
            if (row.check !== checked) {
                let indexElm = arrElem.findIndex(function (oldArrayRow) {
                    return row.index === oldArrayRow.index
                });
                arrElem[indexElm].check = checked;
                checked ? amount += 1 : amount -= 1;
            }
            return row
        });
        this.props.onClickRow({ arrElem: arrElem,
            amount:amount});
    }


    render() {
        const CENTER = {"textAlign": "center", "verticalAlign": "middle"};
        let star = function (bool) {
            if (bool){
                return(<span className="glyphicon glyphicon-star"/>);
            }
        };
        let tbody = this.props.viewElements().map(function (row) {
            return (
                <tr key={row.index} onClick={() => this.onClickRow(row.index)} className={row.check ? "success" : null}>
                    <td style={CENTER}> <input key={row.index} type="checkbox" checked={row.check}/></td>
                    <td>{row.company}</td>
                    <td className="hidden-xs">{row.office}</td>
                    <td style={CENTER} className="hidden-xs">{star(row.main)}</td>
                    <td style={CENTER} className="hidden-xs">{star(row.recrutmentagency)}</td>
                    <td className="hidden-xs">{row.industry}</td>
                    <td>{row.location}</td>
                </tr>);
        }.bind(this));
        let thead = <thead>
        <tr>
            <th style={CENTER}><input type="checkbox" onClick={this.onClickCheckAll}/></th>
            <th>Company</th>
            <th className="hidden-xs">Recipient</th>
            <th className="hidden-xs">Head office</th>
            <th className="hidden-xs">Recruitment agency</th>
            <th className="hidden-xs">Industry</th>
            <th>Area</th>
        </tr>
        <tr className="info">
            <th><input ref={this._filterCheck} onChange={this.onChangeFilter} type="checkbox"/></th>
            <th><input ref={this._filterCompany} type="text" onChange={this.onChangeFilter} className="form-control" placeholder="Filter.." defaultValue={this.props.filterCompany}/></th>
            <th className="hidden-xs"><input ref={this._filterOffice} type="text" onChange={this.onChangeFilter} className="form-control" placeholder="Filter.."/></th>
            <th className="hidden-xs" style={CENTER}><input ref={this._filterMain} onChange={this.onChangeFilter} type="checkbox"/></th>
            <th className="hidden-xs" style={CENTER}><input ref={this._filterAgency} onChange={this.onChangeFilter} type="checkbox"/></th>
            <th className="hidden-xs"><input ref={this._filterIndustry} type="text" onChange={this.onChangeFilter} className="form-control" placeholder="Filter.."/></th>
            <th><input ref={this._filterLocation} type="text" onChange={this.onChangeFilter} className="form-control" placeholder="Filter.."/></th>
        </tr>
        </thead>;
        return(<table className="table table-bordered table-striped table-hover">
                    {thead}
                    <tbody>
                    {tbody}
                    </tbody>
                </table>);
    }
}
