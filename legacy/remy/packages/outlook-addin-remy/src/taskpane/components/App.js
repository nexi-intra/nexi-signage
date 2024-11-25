import * as React from "react";
import { Button, ButtonType, DefaultButton } from "office-ui-fabric-react";
import Header from "./Header";
import HeroList, { HeroListItem } from "./HeroList";
import Progress from "./Progress";
import moment from "moment";
import _ from "lodash";
/* global Button, Header, HeroList, HeroListItem, Progress */
const DEBUGGING = false;
const CAVAURL = "https://cava.nets-intranets.com?id="
const POWERAPPURL = "https://apps.powerapps.com/play/11895e09-d2f9-459b-ac3f-aa3b222d9ab1?tenantId=79dc228f-c8f2-4016-8bf0-b990b6c72e98?id=";

function getSearchParametersFromHRef(href) {
  if (!href) return {};
  var search = {};
  var s1 = href.split("?");
  if (s1.length > 1) {
    var s2 = s1[1].split("&");
    for (let index = 0; index < s2.length; index++) {
      const s3 = s2[index].split("=");
      search[s3[0]] = decodeURIComponent(s3[1]);
    }
  }
  return search;
}

function getSearchParametersFromHash(href) {
  if (!href) return {};
  var search = {};
  var s1 = href.split("#");
  if (s1.length > 1) {
    var s2 = s1[1].split("&");
    for (let index = 0; index < s2.length; index++) {
      const s3 = s2[index].split("=");
      search[s3[0]] = decodeURIComponent(s3[1]);
    }
  }
  return search;
}

function get(property) {
  return new Promise((resolve, reject) => {
    property.getAsync(result => {
      if (result.status !== Office.AsyncResultStatus.Succeeded) {
        return resolve("");
      }
      return resolve(result.value);
    });
  });
}

function getLocation() {
  return get(Office.context.mailbox.item.location);
}

function getItem() {
  return get(Office.context.mailbox.item);
}

function getStart() {
  return get(Office.context.mailbox.item.start);
}

function getEnd() {
  return get(Office.context.mailbox.item.end);
}

function getOrganizer() {
  return get(Office.context.mailbox.item.organizer);
}

function isRecurring() {
  return new Promise((resolve, reject) => {
    Office.context.mailbox.item.recurrence.getAsync(function(asyncResult) {
      if (asyncResult.status === Office.AsyncResultStatus.Succeeded) {
        var recurrence = asyncResult.value;
        if (recurrence === null) {
          resolve(false);
          //console.log("This is a single appointment.");
        } else {
          resolve(true);
          //console.log(`Recurrence pattern: ${JSON.stringify(recurrence)}`);
        }
      } else {
        resolve(false);
        console.error(asyncResult.error);
      }
    });
  });
}
function getBody() {
  return new Promise((resolve, reject) => {
    Office.context.mailbox.item.body.getAsync(Office.CoercionType.Html, function(asyncResult) {
      if (asyncResult.status === Office.AsyncResultStatus.Succeeded) {
        resolve(asyncResult.value);
      } else {
        resolve("");
      }
    });
  });
}

function insertcavaLink(id) {
  return new Promise((resolve, reject) => {
    try {

      var html = "<div style='color:#005776'> <hr/><h2>CAVA - Nets Meeting Services</h2>";
      html +=
        "This is a link used by the organizer of the meeting to order additional services<br/><br/><a " +
        "href='" +
        CAVAURL +
        id +
        "' target='_blank'>Open CAVA</a><br/>" +
        //"<div style='color:#ffffff'>#CAVAIDSTART#"+_.replace(id,"@","-") +"#CAVAIDEND#</div>"+
        "<hr/></div>";

      Office.context.mailbox.item.setSelectedDataAsync(
        html,
        {
          coercionType: Office.CoercionType.Html
        },
        function(asyncResult) {
          if (asyncResult.status === Office.AsyncResultStatus.Succeeded) {
            resolve("Selected text has been updated successfully.");
          } else {
            reject(asyncResult.error);
          }
        }
      );
    } catch (error) {
      reject(error);
    }
  });
}
export default class App extends React.Component {
  constructor(props, context) {
    super(props, context);
    var search = getSearchParametersFromHRef(window.location.search);
    this.state = {
      listItems: [
        { primaryText: "Only one location", icon: "" },
        { primaryText: "No recurrence", icon: "" }
      ],
      page: search.page,
      logs: ["Log"],
      isConnected: false,
      id: Date.now(),
      insertedLinkRun : false
    };
  }

  doLoad = async (existingID) => {
    //    this.log("doload");

    var body = await getBody().catch(error => {
      this.log("ERROR doLoad getBody : " + error);
    });
    if (body && body.indexOf(CAVAURL) > -1) {
      this.setState({ isConnected: true });
    }

    var organizer = await getOrganizer();

    var id = existingID ? existingID : organizer.emailAddress + ":" + this.state.id;

    var start = await getStart();
    var end = await getEnd();
    var location = await getLocation();

    var additionalProps = "&start=" + moment(start).toISOString();
    additionalProps += "&end=" + moment(end).toISOString();
    additionalProps += "&location=" + location;

    var cavaLink = CAVAURL + id + additionalProps;
    var powerAppLink = POWERAPPURL + id + additionalProps;

    this.setState({ cavaLink,powerAppLink,remyId: id });
    this.log("start raw" + start);

    this.log("start moment " + moment(start).toISOString());
  };

  checkLocation = async () => {
    try {
      var location = await getLocation().catch(e => {});
      var body = await getBody();
      if (body.indexOf(CAVAURL) > -1) {
        var s = body.split(CAVAURL);
        var s2 = s[1].split('"');
        var id = s2[0];

        if (this.state.existingID !== id) {
          this.setState({ existingID: id });
          this.doLoad(id)
        }

        console.log(id);
      } else {
        if (this.state.existingID) {
          this.setState({ existingID: "" });
          this.doLoad()
        }else
        {
          if (this.state.existingID)  return
          //if (this.state.remyId) insertcavaLink(this.state.remyId)

        }
      }
      var recurring = await isRecurring();
      this.log("Checking location " + location);
      this.log("Recurring " + recurring);

      if (location && !this.state.insertedLinkRun && !this.state.existingID){
        var organizer = await getOrganizer();
        if (organizer){
        var id = organizer.emailAddress + ":" + this.state.id;
        insertcavaLink(id)
      }
        
      }
      this.setState({ location, recurring });
    } catch (error) {}

    setTimeout(this.checkLocation, 500);
  };
  componentDidMount() {
    //    this.log("mounted");
    setTimeout(this.checkLocation, 500);
    this.doLoad(this.state.existingID);
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevProps.isOfficeInitialized !== this.props.isOfficeInitialized) {
      //      this.log("updated");
      this.doLoad(this.state.existingID);
    }
  }

  log = entry => {
    this.state.logs.push(entry);
    this.setState({ logs: this.state.logs });
  };
  click = async () => {
    try {
      var organizer = await getOrganizer();
      var timestamp = Date.now();
      var id = this.state.existingID ? this.state.existingID : organizer.emailAddress + ":" + timestamp;

      var body = await getBody().catch(error => {
        this.log("ERROR reading body: " + error);
      });

      if (!this.state.existingID) {
        var insertStatus = await insertcavaLink(id).catch(error => {
          this.log("ERROR insertcavaLink: " + error);
        });
        if (insertStatus) this.setState({ isConnected: true });
      } else {
        this.setState({ isConnected: true });
        this.log("Already linked");
      }
    } catch (error) {
      this.log("ERROR general: " + error.message);
    }
  };
  debug = async () => {
    try {
      var item = await getStart();
      this.log("Item" + JSON.stringify(item));
    } catch (error) {
      this.log("Error " + error.message);
    }
  };

  render() {
    const { title, isOfficeInitialized } = this.props;

    if (!isOfficeInitialized) {
      return (
        <Progress title={title} logo="assets/cava-icon.png" message="Please sideload your addin to see app body." />
      );
    }

    var orderButtonLabel = "Open Order Form";
    switch (this.state.page) {
      case "catering":
        orderButtonLabel = "Order Catering";
        break;
      case "visitor":
        orderButtonLabel = "Register Visitors";
        break;

      case "av":
        orderButtonLabel = "Order A/V Equipment";

        break;

      default:
        break;
    }

    return (
      <div className="ms-welcome">
        {this.state.location && !this.state.recurring && (
          <div style={{ textAlign: "center", marginTop: "20px" }}>
          
            <iframe style={{border:"0px" ,width:"90vw",height:"90vh"}} src={this.state.powerAppLink + "&page=" + this.state.page}></iframe>
            <DefaultButton
            style={{right:"10px", bottom:"10px",position: "fixed"}}
            onClick={() => {
              
              // if (this.state.existingID)  return
              // insertcavaLink(this.state.remyId)
            }}
            href={this.state.powerAppLink + "&page=" + this.state.page}
            target="_blank"
          >
            Open in Browser
          </DefaultButton>

          </div>
        )}

        {(!this.state.location || this.state.recurring) && (
          <div>
            <Header logo="assets/cava-icon.png" title={this.props.title} message="CAVA" />

            <div style={{ padding: "20px" }}>
              <h1>Nets Meeting Services</h1>
              <p>
                All you have to do is to add one location to your meeting so we know where to deliver to and in which
                reception the visitors is expected to arrive.
              </p>

              <p>
                <ul style={{ marginLeft: "10px" }}>
                  <li style={{ padding: "5px" }}>
                    Add visitors which is not a part of the invitation to your meeting.
                  </li>
                  <li style={{ padding: "5px" }}>Order catering and A/V equipment</li>
                </ul>
              </p>

              <p>Note that we currently don't support recurring appointments and multi location meetings</p>
              <p>
                If you have questions about this functionality, contact Group IT
              </p>
            </div>
          </div>
        )}

        {DEBUGGING && !this.state.isConnected && (
          <div style={{ width: "100vw", padding: "10px" }}>
            <p style={{ display: "none" }}>
              CAVA can assist you in ordering additional services and report Visitors to the reception. In order to CAVA
              to know where to deliver the services, and where to expect the visitors, you need to have a room specified
            </p>

            <Button
              className="ms-welcome__action"
              buttonType={ButtonType.hero}
              xiconProps={{ iconName: "ChevronRight" }}
              onClick={this.click}
            >
              Connect Appointment
            </Button>
          </div>
        )}
        {DEBUGGING && this.state.isConnected && (
          <div>
            <h1>Connected</h1>Keep the CAVA link within your appointment
          </div>
        )}
        {DEBUGGING && (
          <Button className="ms-welcome__action" buttonType={ButtonType.hero} onClick={this.debug}>
            Debug
          </Button>
        )}

        <div>
          {DEBUGGING &&
            this.state &&
            this.state.logs &&
            this.state.logs.map((entry, key) => {
              return <div key={key}>{entry}</div>;
            })}
        </div>
        {!this.state.existingID & this.state.location && (
          <div style={{ backgroundColor:"lightyellow", width:"100%",position: "fixed", left: "0px", top: "0px",padding:"10px" }}>Click in the description field to link to CAVA</div>
          )}
        {this.state.existingID && (
        <div style={{ position: "fixed", left: "10px", bottom: "10px" }}>{this.state.existingID}:{this.state.page}</div>
        )}
      </div>
    );
  }
}
