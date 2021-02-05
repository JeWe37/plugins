{#

Copyright (C) 2021 Frank Wall
OPNsense® is Copyright © 2014 – 2016 by Deciso B.V.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

#}

<script>
    $( document ).ready(function() {
        /**
         * show HAProxy config
         */
        function update_showconf() {
            ajaxCall(url="/api/haproxy/export/config/", sendData={}, callback=function(data,status) {
                $("#showconf").text(data['response']);
            });
        }
        update_showconf();

        /**
         * download HAProxy config
         */
        $('[id*="exportbtn"]').each(function(){
            $(this).click(function(){
                var type = $(this).data("type");
                ajaxGet("/api/haproxy/export/download/"+type+"/", {}, function(data, status){
                    if (data.filename !== undefined) {
                        var link = $('<a></a>')
                            .attr('href','data:'+data.filetype+';base64,' + data.content)
                            .attr('download', data.filename)
                            .appendTo('body');

                        link.ready(function() {
                            link.get(0).click();
                            link.empty();
                        });
                    }
                });
            });
        });

    });
</script>

<ul class="nav nav-tabs" role="tablist" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#export"><b>{{ lang._('Config Export') }}</b></a></li>
</ul>

<div class="content-box tab-content">

    <div id="export" class="tab-pane fade in active">
        <div class="content-box" style="padding-bottom: 1.5em;">
            <pre id="showconf"></pre>
            <div class="col-md-12">
                <hr />
                <button class="btn btn-primary" id="exportbtn" data-type="config" type="button"><b>{{ lang._('Download Config') }}</b></button>
                <button class="btn btn-primary" id="exportbtn" data-type="all" type="button"><b>{{ lang._('Download All') }}</b></button>
            </div>
        </div>
    </div>

</div>

{{ partial("layout_partials/base_dialog_processing") }}
