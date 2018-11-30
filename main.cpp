#include <iostream>
#include <pcap.h>
using namespace std;

void onPacket(u_char* args, const struct pcap_pkthdr* hdr, const u_char* packet)
{
    cout << "packet len: " << hdr->len << endl;
}

int main(int argc, char* argv[])
{
    char errbuf[PCAP_ERRBUF_SIZE];
    char* dev = pcap_lookupdev(errbuf); 
    cout << "Hello, Pcap " << dev << "!" << endl;
    pcap_t* pcap = pcap_open_live(dev, BUFSIZ, 1, 1000, errbuf);
    if(!pcap || pcap_datalink(pcap) != DLT_EN10MB)
    {
        cout << (!pcap ? errbuf : "datalink type not expected.") << endl;
        return 1;
    }
    struct pcap_pkthdr h;
    const u_char* pPacket = pcap_next(pcap, &h);
    cout << "packet len: " << h.len << endl;
    pcap_loop(pcap, -1, onPacket, NULL);
    pcap_close(pcap);
    return 0;
}