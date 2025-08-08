// handle two column layout on 1000px breakpoint
const handleColumns = () => {

    // main element is the flex container for the columns
    const $MAIN = document.querySelector('main');

    // verify breakpoint width
    if (document.querySelector('html').clientWidth >= 1000) {

        // halve height for main to force flex columns to wrap
        $MAIN.style.height = 'auto'; // reset before performing calculation
        let columnsHeight = $MAIN.clientHeight / 2;
        $MAIN.style.height = `${columnsHeight}px`;

        // handle element that wraps onto third column
        // find distance between 2nd to last element and bottom of body
        const columnElements = Array.from(document.querySelectorAll('main > *'));
        columnElements.sort((a, b) => getComputedStyle(a).order - getComputedStyle(b).order); // sorted by render order
        
        const overflowElement = columnElements[columnElements.length - 1];
        const anchorElement = columnElements[columnElements.length - 2];
        const col2Gap = $MAIN.getBoundingClientRect().bottom - anchorElement.getBoundingClientRect().bottom;
        console.log(col2Gap);
        console.log(overflowElement.clientHeight);
        const neededHeight = overflowElement.clientHeight - col2Gap
        console.log(neededHeight);
        console.log(col2Gap + neededHeight);
        console.log(columnsHeight);
        columnsHeight += neededHeight + 32;
        console.log(columnsHeight);
        $MAIN.style.height = `${columnsHeight}px`;

        // set precise main height to begin with
            // halve main height
            // use that value to find first element that will wrap onto 2nd column
                // calculate height of 1st element to last before wrap
                // calculate height of 1st wrap element to end
                // set main height to larger of these two values (the longer of the two columns)
        
        // calculate width of body - left and right padding
        const $BODY = document.querySelector('body');
        const getBodyWidth = () => {
            const BODY_STYLES = getComputedStyle($BODY);
            let bodyWidth = $BODY.clientWidth;
            bodyWidth -= parseFloat(BODY_STYLES.paddingLeft) + parseFloat(BODY_STYLES.paddingRight);
            return bodyWidth;
        }

        // multiply width of main by 2 and add 1em for the flex gap
        const calcColumnsWidth = () => {
            const MAIN_STYLES = getComputedStyle($MAIN);
            const mainWidth = $MAIN.clientWidth;
            const columnsWidth = (mainWidth * 2) + parseFloat(MAIN_STYLES.gap);
            return columnsWidth;
        }

        // set main left margin to half of bodyWidth - columnsWidth
        const mainLeftMargin = (getBodyWidth() - calcColumnsWidth()) / 2;
        $MAIN.style.marginLeft = `${mainLeftMargin}px`;

    } else {
        $MAIN.style.height = 'auto';
        $MAIN.style.marginLeft = 'auto';
    }
}

window.addEventListener('DOMContentLoaded', handleColumns);
window.addEventListener('resize', handleColumns);